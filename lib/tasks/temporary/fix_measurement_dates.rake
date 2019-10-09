namespace :measurements do
  desc "Fix measurements dates (re-import)"
  task fix_dates: :environment do
    import = Import.first
    import_file = "TraitDB-upload-052019.xlsx"

    unless import.xlsx_file.filename.to_s == import_file
      puts "This script has been written for '#{import_file}'"
      exit 1
    end

    url = Rails.application.routes.url_helpers.rails_blob_url import.xlsx_file

    data_sheet = Roo::Spreadsheet.open(url).sheet("Data Entry")
    parsed     = data_sheet.parse(headers: true)

    parsed.shift # remove the header row
    observations = parsed.group_by { |row| row['resource_name'] }


    observations_to_change = []
    observations.each do |observation|
      next if observation[1].map { |m| m['date'] }.uniq.count == 1

      observations_to_change << observation
    end

    puts "The following observations have measurements with different dates: "
    puts " - " + observations_to_change.map(&:first).join("\n - ")
    puts

    observations_to_change.each do |ref, values|
      reference   = Reference.find_by name: ref
      observation = reference.observations.first

      values.each do |row|
        trait    = Trait.find_by    name: row['trait_name']
        sex      = SexType.find_by  name: row['sex']

        measurement = observation.measurements.where value: row['value'],
          trait: trait, sex_type: sex, sample_size: row['sample_size'],
          notes: row['notes']

        measurement = measurement.first

        measurement.update date: row['date']

        print "."
      end
    end

    puts
    puts

    puts "All done now!"
  end
end
