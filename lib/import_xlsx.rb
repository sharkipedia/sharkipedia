module ImportXlsx
  class DataImport
    attr_reader :xlsx
    attr_accessor :log, :valid

    @allowed_sheet_names = []
    @allowed_headers = []

    def initialize(file_path)
      @xlsx   = Roo::Spreadsheet.open(file_path)
      @valid  = false
      @log    = ""

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

        sheet_names = @allowed_sheet_names.join(' & ')
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

      if self.valid
        self.log += "\nAll automated validations passed.\n"
      else
        self.log += "\nThe automated validations failed. The file can not be " \
                    "imported. Please fix the abovementioned issues and " \
                    "resubmit the file.\n"
      end
    end


    def import
      raise "note implement"
    end
  end

  class Traits < DataImport
    def initialize(file_path)
      @allowed_headers = %w(
        observation_id hidden resource_name resource_doi
        secondary_resource_name secondary_resource_doi species_superorder
        species_name marine_province location_name lat long date sex
        trait_class trait_name standard_name method_name model_name value
        value_type precision precision_type precision_upper sample_size dubious
        validated validation_type notes contributor_id depth
      )

      @allowed_sheet_names = ["Data Entry", "Values"]

      super
    end

    def import
      parsed = @data_entry_sheet.parse(headers: true)
      parsed.shift # remove the header row

      resources = parsed.map do |row|
        row['resource_name']
      end.uniq

      self.log += "The sheet contains #{resources.count} observation(s)\n"

      # cluster by resource
      observations = parsed.group_by { |row| row['resource_name'] }
      observations.each do |resource_name, sub_table|

        self.log += "Starting import of observation #{resource_name}\n"

        # Create Resources

        resources = sub_table.map do |row|
          [row['resource_name'], row['resource_doi']]
        end.uniq

        resources += sub_table.map do |row|
          [row['secondary_resource_name'], row['secondary_resource_doi']]
        end.uniq

        resources.reject! { |name, _| name.blank? }

        self.log += "Found resources: #{resources.inspect}\n"

        referenced_resources = resources.map do |name, doi|

          resource = Resource.find_by name: name
          if resource
            resource.doi ||= doi
            resource.save
          else
            resource = Resource.create name: name, doi: doi
          end

          resource
        end

        self.log += referenced_resources.inspect + "\n"

        # species_name
        sanity_check sub_table, 'species_name', resource_name
        # XXX: what should happen if the species / species super order can't be found?
        species = Species.find_by name: sub_table.first['species_name']
        self.log += species.inspect + "\n"

        # marine_province - might be blank
        sanity_check sub_table, 'marine_province', resource_name
        marine_province = LonghurstProvince.find_by name: sub_table.first['marine_province']
        self.log += marine_province.inspect + "\n"

        # find or create Location: location_name    lat    long
        sanity_check sub_table, 'location_name', resource_name
        sanity_check sub_table, 'lat', resource_name
        sanity_check sub_table, 'long', resource_name

        location_name = sub_table.first['location_name']
        location_lat  = sub_table.first['lat']
        location_long = sub_table.first['long']

        if location_name.blank? && location_lat.blank? && location_long.blank?
          raise "location name and lat/long can't be blank!"
        elsif !location_name.blank? && location_lat.blank? && location_long.blank?
          location = Location.find_by name: location_name
        elsif location_name.blank? && !location_lat.blank? && !location_long.blank?
          location = Location.find_by lat: location_lat, lon: location_long
        end

        unless location
          location = Location.create name: location_name, lat: location_lat, lon: location_long
        end
        self.log += location.inspect + "\n"

        date = sub_table.first['date']
        self.log += date.inspect + "\n"

        contributor_id = sub_table.first['contributor_id']
        self.log += contributor_id.inspect + "\n"

        hidden = sub_table.first['hidden']
        self.log += hidden.inspect + "\n"

        # TODO: find observation by resource name
        observation = Observation.joins(:resources)
                                 .where(contributor_id: contributor_id,
                                        'resources.name': resource_name)
                                 .first

        unless observation
          observation = Observation.create! species: species,
            longhurst_province: marine_province,
            location: location,
            date: date,
            resources: referenced_resources,
            hidden: hidden,
            contributor_id: contributor_id
        end

        self.log += observation.inspect + "\n"

        sub_table.each do |row|
          sex = SexType.find_by name: row['sex']
          trait_class = TraitClass.find_by name: row['trait_class']
          trait = Trait.find_by name: row['trait_name']
          standard = Standard.find_by name: row['standard_name']
          measurement_method = MeasurementMethod.find_by name: row['method_name']
          measurement_model = MeasurementModel.find_by name: row['model_name']
          value = row['value']
          value_type = ValueType.find_by name: row['value_type']
          precision = row['precision']
          precision_type = PrecisionType.find_by name: row['precision_type']
          precision_upper = row['precision_upper']
          sample_size = row['sample_size']
          dubious = row['dubious']
          validated = row['validated']
          validation_type = row['validation_type']
          notes = row['notes']
          depth = row['depth']

          observation.measurements.create! sex_type: sex,
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
            notes: notes,
            depth: depth
        end

        self.log += observation.measurements.map(&:inspect).join("\n")
      end
    rescue => e
      self.log += "ERROR: Import failed!\n"
      self.log += e.to_s
      return false
    end

    private

    def sanity_check table, field, resource
      if table.map { |row| row[field] }.uniq.size > 1
        raise "more than one species in observation #{resource} detected."
      end
    end
  end

  class Trends < DataImport
    def initialize(file_path)
      @allowed_sheet_names = ["Data", "Notes"]

      super

      @allowed_headers = %w( Class Order Family Genus Species Binomial IUCNcode
      SourceYear Taxonomic\ Notes AuthorYear DataSource Units SamplingMethod
      SamplingMethodCode Location Latitude Longitude Ocean DataType NoYears
      TimeMin PageAndFigureNumber LineUsed PDFPage ActualPage Depth Model
      FigureName FigureData)

      # allow year-columns
      year_columns = @data_entry_sheet.row(1).map(&:to_s)
                                             .select { |e| e =~ /\d{4}/ }
      @allowed_headers.push(*year_columns)
    end

    def import

    end
  end
end
