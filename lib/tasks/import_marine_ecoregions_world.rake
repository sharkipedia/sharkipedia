namespace :import do
  desc "Import MarineEcoregionsWorld"
  task marine_ecoregions_worlds: :environment do
    if MarineEcoregionsWorld.count == 269
      puts "MarineEcoregionsWorld already imported"
      exit 1
    end

    marine_ecoregions_worlds = JSON.parse(File.read("docs/ppow-meow.json"))
    marine_ecoregions_worlds.each do |entry|
      MarineEcoregionsWorld.create! unep_fid: entry["FID"],
                                    region_type: entry["TYPE"],
                                    province: entry["PROVINC"],
                                    ecoregion: entry["ECOREGION"],
                                    biome: entry["BIOME"],
                                    trend_reg_id: entry["TREND_REG_ID"]
    end
  end
end
