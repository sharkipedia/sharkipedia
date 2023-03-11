module ImportXlsx
  class DataImport
    attr_reader :xlsx, :user
    attr_accessor :log, :valid

    @allowed_sheet_names = []
    @allowed_headers = []

    def initialize(file_path, user, import)
      @xlsx = Roo::Spreadsheet.open(file_path)
      @valid = false
      @log = ""
      @user = user
      @import = import

      @data_entry_sheet = xlsx.sheet(@allowed_sheet_names.first)
    end

    # Check if the spreadsheet confirms with the template
    #
    # it would be nice if this wasn't hard-coded. ie. the actual template would
    # be used to validate.
    def validate
      self.valid = true
      self.log += "Automatic validations:\n\n"

      if xlsx.sheets == @allowed_sheet_names
        self.log += "OK: Sheet names comply with the template\n"
      else
        self.valid = false

        sheet_names = @allowed_sheet_names.join(" & ")
        self.log += "ERROR: The sheets are not named #{sheet_names}\n"
      end

      # TODO: do something a bit prettier than this :/
      headers = @data_entry_sheet.row(1).map(&:to_s).map(&:strip)

      if headers.sort == @allowed_headers.sort
        self.log += "OK: Data sheet column headers comply with the template.\n"
      else
        self.valid = false
        self.log += "ERROR: Data sheet column headers do not comply with the template\n"
        self.log += "allowed: #{@allowed_headers.inspect}\n"
        self.log += "found: #{headers.inspect}\n"
        self.log += "difference: #{(headers - @allowed_headers).inspect}\n"
      end

      # TODO: Check if referenced species exists / have the user select
      # a species during upload and pull that in from the import object

      self.log += if valid
        "\nAll automated validations passed.\n"
      else
        "\nThe automated validations failed. The file can not be " \
                    "imported. Please fix the abovementioned issues and " \
                    "resubmit the file.\n"
      end
    end

    def import
      raise "note implement"
    end
  end

  class Traits < DataImport
    def initialize(file_path, user, import)
      @allowed_headers = %w[
        observation_id hidden resource_name resource_doi
        secondary_resource_name secondary_resource_doi species_superorder
        species_name marine_province location_name lat long date sex
        trait_class trait_name standard_name method_name model_name value
        value_type precision precision_type precision_upper sample_size dubious
        validated validation_type notes contributor_id depth
      ]

      @allowed_sheet_names = ["Data Entry", "Values"]

      super
    end

    def import
      ActiveRecord::Base.transaction do
        parsed = @data_entry_sheet.parse(headers: true)
        parsed.shift # remove the header row

        resources = parsed.map { |row|
          row["resource_name"]
        }.uniq

        self.log += "The sheet contains #{resources.count} observation(s)\n"

        # cluster by resource
        observations = parsed.group_by { |row| row["resource_name"] }
        observations.each do |resource_name, sub_table|
          self.log += "Starting import of observation #{resource_name}\n"

          # Create References

          resources = sub_table.map { |row|
            [row["resource_name"], row["resource_doi"]]
          }.uniq

          resources += sub_table.map { |row|
            [row["secondary_resource_name"], row["secondary_resource_doi"]]
          }.uniq

          resources.reject! { |name, _| name.blank? }

          self.log += "Found resources: #{resources.inspect}\n"

          resources.map! do |name, doi|
            [name.strip, doi.try(:strip)]
          end

          referenced_resources = resources.map do |name, doi|
            if (resource = Reference.find_by(name:))
              resource.doi ||= doi
              resource.save
              resource
            else
              Reference.create name:, doi:
            end
          end

          self.log += referenced_resources.inspect + "\n"

          date = sub_table.first["date"]
          self.log += date.inspect + "\n"

          contributor_id = sub_table.first["contributor_id"]
          self.log += contributor_id.inspect + "\n"

          hidden = sub_table.first["hidden"]
          self.log += hidden.inspect + "\n"

          depth = sub_table.first["depth"]
          self.log += depth.inspect + "\n"

          # TODO: find observation by resource name
          observation = Observation.joins(:references)
            .where(contributor_id:,
              "references.name": resource_name)
            .first

          observation ||= Observation.create! references: referenced_resources,
            hidden:,
            contributor_id:,
            depth:,
            user:,
            import: @import

          self.log += observation.inspect + "\n"

          sub_table.each do |row|
            # XXX: what should happen if the species / species super order can't be found?
            species = Species.find_by name: row["species_name"]
            species ||= Species.find_by edge_scientific_name: row["species_name"]
            self.log += species.inspect + "\n"

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
            validated = row["validated"].to_i == 1
            date = row["date"]
            validation_type = ValidationType.find_by name: row["validation_type"]
            notes = row["notes"]

            location_name = row["location_name"]
            location_lat = row["lat"]
            location_long = row["long"]

            if location_name.blank? && location_lat.blank? && location_long.blank?
              raise "location name and lat/long can't be blank!"
            elsif !location_name.blank? && location_lat.blank? && location_long.blank?
              location = Location.find_by name: location_name
            elsif location_name.blank? && !location_lat.blank? && !location_long.blank?
              location = Location.find_by lat: location_lat, lon: location_long
            end

            location ||= Location.create name: location_name, lat: location_lat, lon: location_long
            self.log += location.inspect + "\n"

            # marine_province - might be blank
            marine_province = LonghurstProvince.find_by name: sub_table.first["marine_province"]
            self.log += marine_province.inspect + "\n"

            observation.measurements.create! species:,
              sex_type: sex,
              trait_class:,
              trait:,
              standard:,
              measurement_method:,
              measurement_model:,
              date:,
              value:,
              value_type:,
              precision:,
              precision_type:,
              precision_upper:,
              sample_size:,
              dubious:,
              validated:,
              validation_type:,
              notes:,
              location:,
              longhurst_province: marine_province
          end

          self.log += observation.measurements.map(&:inspect).join("\n")
        end
      end
    rescue => e
      Bugsnag.notify(e)

      self.log += "ERROR: Import failed!\n"
      self.log += "#{e}\n"
      self.log += e.backtrace.join("\n")
      false
    end

    private

    def species_check sub_table, resource_name
      if sub_table.first["species_name"].blank?
        self.log += "ATTN: No species_name set for #{resource_name}"
        return false
      end

      begin
        sanity_check sub_table, "species_name", resource_name
      rescue => e
        self.log += e.message
        return false
      end

      true
    end

    def sanity_check table, field, resource
      items = table.map { |row| row[field] }.uniq
      if items.size > 1
        raise "more than one #{field} in observation #{resource} detected: #{items.inspect}"
      end
    end
  end

  class Trends < DataImport
    def initialize(file_path, user, import)
      @allowed_sheet_names = ["Data"]

      super

      @allowed_headers = %w[

        Superorder Order Family Genus Species Source_year AuthorYear
        DataSource Source_observation General_data_type Unit Unit_time
        Unit_spatial Unit_gear Unit_transformation Unit_freeform Model
        Sampling_method_general Sampling_method_info Dataset_location
        Dataset_representativeness_experts Experts_for_representativeness
        Coastal_province Pelagic_province FAO_area Dataset_map Latitude
        Longitude Ocean Datamined Variance PageAndFigureNumber LineUsed
        PDFPage ActualPage FigureName FigureData Comments

      ]

      # allow year-columns
      year_columns = @data_entry_sheet.row(1).map(&:to_s)
        .select { |e| e =~ /\d{4}/ }
      @allowed_headers.push(*year_columns)
    end

    def import
      ActiveRecord::Base.transaction do
        parsed_tbl = @data_entry_sheet.parse # .parse(headers: true)
        # parsed.shift # remove the header row

        p_1 = @data_entry_sheet.row 1

        self.log += "The sheet contains #{parsed_tbl.count} trend(s)\n"
        parsed_tbl.each do |p_2|
          row = p_1.zip(p_2).to_h

          self.log += "\n"

          # check if single or species group
          species, species_group = nil
          if row["Species"].include? ","
            species_group = SpeciesGroup.find_or_create_by name: "#{row["Genus"].try(:strip)} #{row["Species"].try(:strip)}"
            self.log += "-> #{species_group.inspect}\n"

            row["Species"].split(/,\s*/).each do |name|
              # double groups
              binomial = if name.include?(".")
                genera = row["Genus"].split(/,\s*/)

                genus = genera.find { |genus| genus.starts_with? name[0] }
                name.sub name[0..1], genus
              else
                "#{row["Genus"].try(:strip)} #{name.try(:strip)}"
              end

              s = Species.find_by name: binomial
              self.log += "==> Found species #{binomial} => #{s.inspect}\n"
              species_group.species << s unless species_group.species.include?(s)
            end
          else
            binomial = "#{row["Genus"].try(:strip)} #{row["Species"].try(:strip)}"
            species = Species.find_by name: binomial
            self.log += "Found species #{binomial} => #{species.inspect}\n"

            # NOTE: spp when species is unknown
          end

          if species.blank? && species_group.blank?
            self.log += "Couldn't find species / species_group for #{row["Species"]}\n"

            next
          end

          ref = row["AuthorYear"]
          if ref.blank?
            self.log += "\nSKIPPING - no AuthorYear: #{row.inspect}\n"
            next
          else
            ref = ref.sub("_", "")
          end
          resource = Reference.where("lower(name) = ?", ref.downcase).first
          if resource
            self.log += "Found Reference: #{resource.inspect}\n"
          else
            doi, data_source = nil
            if /^10./.match?(row["DataSource"])
              doi = row["DataSource"]
            else
              data_source = row["DataSource"]
            end
            resource ||= Reference.find_or_create_by! name: ref,
              data_source:,
              doi:,
              year: row["SourceYear"]

            self.log += "Created Reference: #{resource.inspect}\n"
          end

          # Latitude has a space at the end
          location = Location.find_or_create_by name: row["Dataset_location"],
            lat: (row["Latitude"] || row["Latitude "]),
            lon: row["Longitude"]
          self.log += "#{location.inspect}\n"

          data_type = DataType.find_or_create_by name: row["General_data_type"]
          self.log += "#{data_type.inspect}\n"

          unit = Standard.find_or_create_by name: row["Unit"]
          self.log += "#{unit.inspect}\n"

          unit_freeform = row["Unit_freeform"].sub "NA", ""
          unit_time = UnitTime.find_or_create_by(name: row["Unit_time"]) unless row["Unit_time"] == "NA"
          unit_spatial = UnitSpatial.find_or_create_by(name: row["Unit_spatial"]) unless row["Unit_spatial"] == "NA"
          unit_gear = UnitGear.find_or_create_by(name: row["Unit_gear"]) unless row["Unit_gear"] == "NA"
          unit_transformation = UnitTransformation.find_or_create_by(name: row["Unit_transformation"]) unless row["Unit_transformation"] == "NA"
          analysis_model = AnalysisModel.find_or_create_by(name: row["Model"]) unless row["Model"] == "NA"

          sampling_method = SamplingMethod.find_or_create_by(name: row["Sampling_method_general"]) unless row["Sampling_method_general"] == "NA"
          self.log += "#{sampling_method.inspect}\n"

          trend = Trend.create! actual_page: row["ActualPage"],
            depth: row["Depth"],
            figure_data: row["FigureData"],
            figure_name: row["FigureName"],
            line_used: row["LineUsed"],
            analysis_model:,
            page_and_figure_number: row["PageAndFigureNumber"],
            pdf_page: row["PDFPage"],
            comments: row["Comments"],
            reference: resource,
            species:,
            species_group:,
            location:,
            data_type:,
            standard: unit,
            sampling_method:,
            user:,
            start_year: 2900,
            end_year: 2900,
            unit_freeform:,
            unit_time:,
            unit_spatial:,
            unit_gear:,
            unit_transformation:,
            sampling_method_info: row["Sampling_method_info"],
            variance: (row["Variance"] == "Y"),
            dataset_map: (row["Dataset_map"] == "Y"),
            data_mined: (row["Datamined"] == "Y"),
            dataset_representativeness_experts: row["Dataset_representativeness_experts"],
            experts_for_representativeness: row["Experts_for_representativeness"],
            import: @import

          row["Ocean"].downcase.split(/,\s?/).each do |ocean_name|
            ocean = Ocean.where("lower(name) = ?", ocean_name).first
            self.log += "#{ocean.inspect}\n"
            trend.oceans << ocean
          end

          source_observations = SourceObservation.where name: row["Source_observation"]
          trend.source_observations = source_observations

          marine_provinces = MarineEcoregionsWorld.where(
            region_type: "MEOW",
            trend_reg_id: [
              row["Coastal_province"].to_s.split(",").map(&:to_i)
            ].flatten
          ).or(
            MarineEcoregionsWorld.where(
              region_type: "PPOW",
              trend_reg_id: [
                row["Pelagic_province"].to_s.split(",").map(&:to_i)
              ].flatten
            )
          )

          trend.marine_ecoregions_worlds = marine_provinces

          fao_areas = FaoArea.where(
            f_area: [
              row["FAO_area"].to_s.split(",")
            ].flatten
          )
          trend.fao_areas = fao_areas

          self.log += "Created Trend: #{trend.inspect}\n"

          year_columns = @data_entry_sheet.row(1).map(&:to_s).select { |e| e =~ /\d{4}/ }

          year_columns.each do |year_col|
            value = row[year_col.to_i]
            next if value.blank? || value == "NA" || value == "na"

            if trend.start_year == 2900
              trend.start_year = year_col
            end
            trend.end_year = year_col

            to = trend.trend_observations.create! value:, year: year_col

            self.log += "Created TrendObservation #{to.inspect}\n"
          end

          trend.no_years = trend.end_year - trend.start_year + 1

          trend.save!
          self.log += "\n"
        end
      end
    rescue => e
      Bugsnag.notify(e)

      self.log += "ERROR: Import failed!\n"
      self.log += "#{e}\n"
      self.log += e.backtrace.join("\n")
      false
    end
  end
end
