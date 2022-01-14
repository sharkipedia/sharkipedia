namespace :import do
  desc "Import MarineEcoregionsWorld"
  task marine_ecoregions_worlds: :environment do
    savepoint = []

    if MarineEcoregionsWorld.count > 200
      puts "Clearing duplicate MarineEcoregionsWorld entries"

      Trend.find_each do |trend|
        savepoint << [
          trend.id,
          trend.marine_ecoregions_worlds.where(region_type: "MEOW").map(&:trend_reg_id).uniq,
          trend.marine_ecoregions_worlds.where(region_type: "PPOW").map(&:trend_reg_id).uniq
        ]
      end

      MarineEcoregionsWorld.destroy_all
    end

    marine_ecoregions_worlds = CSV.read("docs/ppow-meow.csv", headers: true)
      .map(&:to_h)

    marine_ecoregions_worlds.each do |entry|
      MarineEcoregionsWorld.find_or_create_by! region_type: entry["TYPE"],
        province: entry["PROVINCE"],
        trend_reg_id: entry["FIRST_NUMB"]
    end

    savepoint.each do |trend_id, meow_ids, ppow_ids|
      trend = Trend.find trend_id
      marine_provinces = MarineEcoregionsWorld.where(
        region_type: "MEOW",
        trend_reg_id: meow_ids
      ).or(
        MarineEcoregionsWorld.where(
          region_type: "PPOW",
          trend_reg_id: ppow_ids
        )
      )
      trend.marine_ecoregions_worlds = marine_provinces
      trend.save!
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
      Ocean.find_or_create_by name:
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
