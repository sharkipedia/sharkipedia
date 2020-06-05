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

  desc "Seed Unit Spatial"
  task unit_spatial: :environment do
    %w[
      1000000m3 km km2 quarter square_nautical_mile_area_swept
    ].each do |name|
      UnitSpatial.find_or_create_by! name: name
      print "."
    end

    puts ""
  end

  desc "Seed Unit Gear"
  task unit_gear: :environment do
    %w[
      10000hook 1000hook 100hook 100net 10power-3hook 50hook BRUV angler dive
      drumline gillnet_day haul hook km-lift km.net kmnet lift line net set
      tow trawl
    ].each do |name|
      UnitGear.find_or_create_by! name: name
      print "."
    end

    puts ""
  end
end
