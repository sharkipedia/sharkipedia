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

  desc "Seed Unit Transformation"
  task unit_transformation: :environment do
    [
      "N/Nmsy",
      "Weighted mean across models",
      "average betweem summer and fall",
      "divided by 1 st year",
      "divided by coefficient of variation",
      "divided by maximum",
      "divided_by_1000",
      "divided_by_first_value",
      "divided_by_max",
      "divided_by_mean",
      "divided_by_unfished_biomass",
      "ln",
      "log",
      "log10",
      "mean",
      "million",
      "multiplied by 100000",
      "normalised",
      "relative to 2001",
      "relative to first year"
    ].each do |name|
      UnitTransformation.find_or_create_by! name: name
      print "."
    end

    puts ""
  end
end
