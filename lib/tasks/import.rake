namespace :import do
  desc "Seed Source Observations"
  task source_observations: :environment do
    %w[
      fisheries fishery_independent scientific stock_assessment other
    ].each do |name|
      SourceObservation.find_or_create_by! name: name
      print "."
    end

    puts ""
  end

  desc "Seed Unit Time"
  task unit_time: :environment do
    %w[
      100hour day fisherday half_hour hour hoursoak month trip
    ].each do |name|
      UnitTime.find_or_create_by! name: name
      print "."
    end

    puts ""
  end
end
