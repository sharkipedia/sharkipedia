class CreateJoinTableTrendsMarineEcoregionsWorld < ActiveRecord::Migration[6.0]
  def change
    create_join_table :marine_ecoregions_worlds, :trends do |t|
      t.index [:marine_ecoregions_world_id, :trend_id], name: "marine_ecoregions_worlds_trends_index"
      t.index [:trend_id, :marine_ecoregions_world_id], name: "trends_marine_ecoregions_worlds_index"
    end
  end
end
