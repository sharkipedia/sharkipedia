module XlsxImport
  def import(file)
    puts
    puts

    # 1. Open spreadsheet
    # xlsx = Roo::Spreadsheet.open('driggers2004a.xlsx')
    # '/Users/max/Downloads/SharkTraits-Template-Example.xlsx'
    xlsx = Roo::Spreadsheet.open(file)

    # 2. Check if the spreadsheet confirms with the template

    allowed_sheet_names = ["Data Entry", "Values"]

    if xlsx.sheets != allowed_sheet_names
      raise "The sheets are not named #{allowed_sheet_names.join(' & ')}"
    end

    allowed_headers = %w(
      observation_id    hidden    resource_name    resource_doi    secondary_resource_name    secondary_resource_doi    species_superorder    species_name    marine_province    location_name    lat    long    date    sex    trait_class    trait_name    standard_name    method_name    model_name    value    value_type    precision    precision_type    precision_upper    sample_size    dubious    validated    validation_type    notes    contributor_id    depth
    )

    data_entry_sheet = xlsx.sheet('Data Entry')
    headers = data_entry_sheet.row(1)

    if headers != allowed_headers
      raise "The $Data Entry$'s headers do not comply with the template"
    end

    # 3. Parse and sanitize sheet

    parsed = data_entry_sheet.parse(headers: true)
    parsed.shift # remove the header row

    observation_ids = parsed.map do |row|
      row['observation_id']
    end.uniq

    puts "The sheet contains #{observation_ids.count} observations"
    puts

    # cluster by observation
    observations = parsed.group_by { |row| row['observation_id'] }
    observations.each do |observation_id, sub_table|

      puts
      puts "# Starting import of observation #{observation_id}"
      puts

      # Create Resources

      resources = sub_table.map do |row|
        [row['resource_name'], row['resource_doi']]
      end.uniq

      resources += sub_table.map do |row|
        [row['secondary_resource_name'], row['secondary_resource_doi']]
      end.uniq

      resources.reject! { |name, _| name.blank? }

      puts "Found resources: #{resources.inspect}"

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

      puts referenced_resources.inspect

      # species_name
      sanity_check sub_table, 'species_name', observation_id
      # XXX: what should happen if the species / species super order can't be found?
      species = Species.find_by name: sub_table.first['species_name']
      puts species.inspect

      # marine_province - might be blank
      sanity_check sub_table, 'marine_province', observation_id
      marine_province = LonghurstProvince.find_by name: sub_table.first['marine_province']
      puts marine_province.inspect

      # find or create Location: location_name    lat    long
      sanity_check sub_table, 'location_name', observation_id
      sanity_check sub_table, 'lat', observation_id
      sanity_check sub_table, 'long', observation_id

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
      puts location.inspect

      date = sub_table.first['date']
      puts date.inspect

      contributor_id = sub_table.first['contributor_id']
      puts contributor_id.inspect

      hidden = sub_table.first['hidden']
      puts hidden.inspect

      observation = Observation.find_by external_id: observation_id,
                                        contributor_id: contributor_id

      unless observation
        observation = Observation.create! species: species,
          longhurst_province: marine_province,
          location: location,
          date: date,
          resources: referenced_resources,
          hidden: hidden,
          external_id: observation_id,
          contributor_id: contributor_id
      end

      puts observation.inspect

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
    end

    puts
    puts "Total Resource count: #{Resource.count}"
    puts "Total Location count: #{Location.count}"
    puts "Total Observation count: #{Observation.count}"
    puts "Total Measurement count: #{Measurement.count}"
  end

  private

  def self.sanity_check table, field, observation_id
    if table.map { |row| row[field] }.uniq.size > 1
      raise "more than one species in observation #{observation_id} detected."
    end
  end
end
