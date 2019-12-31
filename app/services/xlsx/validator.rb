module Xlsx
  class Validator < ApplicationService
    attr_reader :type, :xlsx, :trait, :trend

    Result = Struct.new(:type, :valid, :messages)

    TRAIT_TEMPLATE = "docs/SharkTraits-Template.xlsx"
    TREND_TEMPLATE = "docs/SharkTrends-Template.xlsx"

    def initialize(file_path)
      @messages = []
      @valid = false
      begin
        @xlsx = Xlsx::Document.new(file_path)
      rescue ArgumentError
        @messages << "Document is not an Excel sheet."
        @type = :invalid
      end

      @trait = Document.new(TRAIT_TEMPLATE)
      @trend = Document.new(TREND_TEMPLATE)
    end

    def call
      guess_type

      unless type == :invalid
        if type != :trends
          validate_column_headers

          @xlsx.data_sheet.each_with_index do |row, idx|
            validate_references row, idx

            validate_species row, idx
            validate_sex row, idx
            validate_trait row, idx
            validate_standard row, idx
            validate_value row, idx

            validate_duplicate row, idx
          end
        else
          @valid = true
        end
      end

      Result.new @type, @valid, @messages
    end

    def guess_type
      return unless @xlsx

      if xlsx.sheets == trend.sheets
        @type = :trends
        @messages << "Document is a 'Trends' dataset."
      elsif !(xlsx.sheets & trend.sheets).empty?
        @type = :trends
        @messages << "Document is probably 'Trends' dataset."
      elsif xlsx.sheets == trait.sheets
        @type = :traits
        @messages << "Document is a 'Traits' dataset."
      elsif !(xlsx.sheets & trait.sheets).empty?
        @type = :traits
        @messages << "Document is probably 'Traits' dataset."
      else
        @type = :invalid
        @messages << "Document type could not be detected."
        @messages << "Validation failed. The document can't be imported."
        @valid = false
      end
    end

    def validate_column_headers
      template = case type
                 when :traits
                   @trait
                 when :trends
                   @trend
      end

      if @xlsx.headers == template.headers
        @messages << "Data-Sheet column headers are valid."
        @valid = true
      else
        missing = template.headers - xlsx.headers
        @messages << "Data-Sheet column headers #{missing} are missing."
      end
    end

    def validate_duplicate row, idx
      name = (row["resource_name"] || row["AuthorYear"]).try(:strip)
      return if name.blank? # this kind of error is handled later

      references = [name, row["secondary_resource_name"]]
      references.reject! { |name| name.blank? }
      referenced_references = references.map { |name, doi|
        Reference.find_by name: name
      }.reject! { |res| res.blank? }

      return if referenced_references.blank? || referenced_references.first.observations.count == 0

      case type
      when :traits
        # this is c&p/hacky from import_xlsx.rb
        species = Species.find_by name: row["species_name"]
        species ||= Species.find_by edge_scientific_name: row["species_name"]
        return unless species

        marine_province = LonghurstProvince.find_by name: row["marine_province"]

        location_name = row["location_name"]
        location_lat = row["lat"]
        location_long = row["long"]

        # TODO: this should be a separate check
        if location_name.blank? && location_lat.blank? && location_long.blank?
          @valid = false
          @messages << "Row #{idx + 2}: location name and lat/long can't be blank!"
        elsif !location_name.blank? && location_lat.blank? && location_long.blank?
          location = Location.find_by name: location_name
        elsif location_name.blank? && !location_lat.blank? && !location_long.blank?
          location = Location.find_by lat: location_lat, lon: location_long
        end

        return unless location

        date = row["date"]
        contributor_id = row["contributor_id"]
        hidden = row["hidden"]
        depth = row["depth"]

        referenced_references.each do |reference|
          observations = reference.observations.where species: species,
                                                      longhurst_province: marine_province,
                                                      location: location,
                                                      date: date,
                                                      hidden: hidden,
                                                      contributor_id: contributor_id,
                                                      depth: depth

          unless observations.blank?
            @messages << "Row #{idx + 2}: WARNING: This observation is already present in database (Observation IDs: #{observations.map(&:id)})."

            observations.each do |observation|
              sex = SexType.find_by name: row["sex"]
              trait_class = TraitClass.find_by name: row["trait_class"]
              trait = Trait.find_by name: row["trait_name"]
              standard = Standard.find_by name: row["standard_name"]
              measurement_method = MeasurementMethod.find_by name: row["method_name"]
              measurement_model = MeasurementModel.find_by name: row["model_name"]
              value = row["value"]
              value_type = ValueType.find_by name: row["value_type"]
              precision = row["precision"]
              precision_type = PrecisionType.find_by name: row["precision_type"]
              precision_upper = row["precision_upper"]
              sample_size = row["sample_size"]
              dubious = row["dubious"]
              validated = row["validated"]
              validation_type = row["validation_type"]
              notes = row["notes"]

              measurements = observation.measurements.where sex_type: sex,
                                                            trait_class: trait_class,
                                                            trait: trait,
                                                            standard: standard,
                                                            measurement_method: measurement_method,
                                                            measurement_model: measurement_model,
                                                            value: value,
                                                            value_type: value_type,
                                                            precision: precision,
                                                            precision_type: precision_type,
                                                            precision_upper: precision_upper,
                                                            sample_size: sample_size,
                                                            dubious: dubious,
                                                            validated: validated,
                                                            validation_type: validation_type,
                                                            notes: notes

              unless measurements.blank?
                @valid = false
                @messages << "Row #{idx + 2}: ERROR: This exact measurement is already present in database (Measurement ID: #{measurements.map(&:id)})."
              end
            end
          end
        end
        # when :trends
        # TODO / XXX: trend template is going to change, so no point in doing
        # this right now.
      end
    end

    def validate_references row, idx
      name = (row["resource_name"] || row["AuthorYear"]).try(:strip)
      if name.blank?
        @valid = false
        field = type == :traits ? "resource_name" : "AuthorYear"
        @messages << "Row #{idx + 2}: No #{field} specified."
      end

      reference = Reference.find_by(name: name)
      if reference
        if reference.observations.count > 0
          @messages << "Row #{idx + 2}: WARNING: Reference #{name} already " \
                       "has observations in the database (Observation IDs: " \
                       "#{reference.observations.map(&:id)})"
        end

        return
      end

      reference = Reference.new name: name,
                                data_source: row["DataSource"].try(:strip),
                                doi: (row["resource_doi"] || row["doi"]).try(:strip),
                                year: row["SourceYear"]

      unless reference.valid?
        @valid = false
        reference.errors.full_messages.each do |message|
          # 0 index + row 1 are headers
          @messages << "Row #{idx + 2}: Reference #{message}"
        end
      end
    end

    def validate_species row, idx
      species_name = (row["species_name"] || row["Species name"]).try(:strip)
      if species_name.blank?
        @valid = false
        @messages << "Row #{idx + 2}: No species specified."
      else
        species = Species.find_by name: species_name
        species ||= Species.find_by edge_scientific_name: species_name
        unless species
          @valid = false
          @messages << "Row #{idx + 2}: Species '#{species_name}' not found in database."
        end
      end
    end

    def validate_sex row, idx
      return if type == :trends

      validate SexType, "sex", row, idx
    end

    def validate_trait row, idx
      return if type == :trends

      validate TraitClass, "trait_class", row, idx
      validate Trait, "trait_name", row, idx
    end

    def validate_standard row, idx
      case type
      when :traits
        validate ::Standard, "standard_name", row, idx
      when :trends
        validate ::Standard, "Units", row, idx
      end
    end

    def validate_value row, idx
      return if type == :trends

      value = row["value"]
      if value.blank?
        @valid = false
        @messages << "Row #{idx + 2}: No value specified."
      end
    end

    def validate klass, field, row, idx
      value = row[field].try(:strip)
      if value.blank?
        @valid = false
        @messages << "Row #{idx + 2}: No #{field} specified."
      else
        obj = klass.find_by name: value
        unless obj
          @valid = false
          @messages << "Row #{idx + 2}: #{klass} '#{value}' not found in database."
        end
      end
    end
  end
end
