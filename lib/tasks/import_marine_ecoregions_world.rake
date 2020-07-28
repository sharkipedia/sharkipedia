namespace :import do
  desc "Import MarineEcoregionsWorld"
  task marine_ecoregions_worlds: :environment do
    if MarineEcoregionsWorld.count == 269
      puts "MarineEcoregionsWorld already imported"
      exit 1
    end

    marine_ecoregions_worlds = JSON.parse(File.read("docs/ppow-meow.json"))
    marine_ecoregions_worlds.each do |entry|
      MarineEcoregionsWorld.create! region_type: entry["TYPE"],
                                    province: entry["PROVINC"],
                                    trend_reg_id: entry["TREND_REG_ID"]
    end
  end

  desc "Import FAO Areas"
  task fao_areas: :environment do
    if FaoArea.count == 19
      puts "FAO Areas already imported"
      exit 1
    end

    puts "Ensuring all Oceans are present in database"
    ["Arctic", "Pacific", "Atlantic", "Indian"].each do |name|
      Ocean.find_or_create_by name: name
    end

    puts "Importing FAO Areas"
    fao = CSV.read("docs/FAO_areas.csv", headers: true)
      .map(&:to_h)
      .select { |e| e["F_LEVEL"] == "MAJOR" }
    fao.each do |entry|
      ocean = Ocean.find_by name: entry["OCEAN"]
      FaoArea.find_or_create_by! f_code: entry["F_CODE"],
                                 f_level: entry["F_LEVEL"],
                                 f_area: entry["F_AREA"],
                                 f_subarea: entry["F_SUBAREA"],
                                 f_division: entry["F_DIVISION"],
                                 f_subdivision: entry["F_SUBDIVISION"],
                                 f_subunit: entry["F_SUBUNIT"],
                                 ocean: ocean,
                                 name: entry["NAME_EN"]
      print "."
    end

    puts
  end
end
