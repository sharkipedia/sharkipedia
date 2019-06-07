module Xlsx
  class Validator < ApplicationService
    attr_reader :type, :xlsx, :trait, :trend

    Result = Struct.new(:type, :valid, :messages)

    TRAIT_TEMPLATE = 'docs/SharkTraits-Template.xlsx'
    TREND_TEMPLATE = 'docs/SharkTrends-Template.xlsx'

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
        validate_column_headers

        @xlsx.data_sheet.each_with_index do |row, idx|
          validate_resources row, idx
          validate_species row, idx
          validate_sex row, idx
          validate_trait row, idx
          validate_standard row, idx
          validate_value row, idx
        end
      end

      return Result.new @type, @valid, @messages
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
        @messages << 'Document type could not be detected.'
        @messages << 'Validation failed. The document can\'t be imported.'
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

    def validate_resources row, idx
      name = (row['resource_name'] || row['AuthorYear']).try(:strip)
      if name.blank?
        @valid = false
        field = type == :traits ? 'standard_name' : 'AuthorYear'
        @messages << "Row #{idx + 2}: No #{field} specified."
      end

      if resource = Resource.find_by(name: name)
        if resource.observations.count > 0
          @messages << "Row #{idx + 2}: WARNING: Resource #{name} already has observations in the database (Observation IDs: #{resource.observations.map(&:id)})"
        end

        return
      end

      resource = Resource.new name: name,
        data_source: row['DataSource'].try(:strip),
        doi: (row['resource_doi'] || row['doi']).try(:strip),
        year: row['SourceYear']

      unless resource.valid?
        @valid = false
        resource.errors.full_messages.each do |message|
          # 0 index + row 1 are headers
          @messages << "Row #{idx + 2}: Resource #{message}"
        end
      end
    end

    def validate_species row, idx
      species_name = (row['species_name'] || row['Species name']).try(:strip)
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

      validate SexType, 'sex', row, idx
    end

    def validate_trait row, idx
      return if type == :trends

      validate TraitClass, 'trait_class', row, idx
      validate Trait, 'trait_name', row, idx
    end

    def validate_standard row, idx
      case type
      when :traits
        validate Standard, 'standard_name', row, idx
      when :trends
        validate Standard, 'Units', row, idx
      end
    end

    def validate_value row, idx
      return if type == :trends

      value = row['value']
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
