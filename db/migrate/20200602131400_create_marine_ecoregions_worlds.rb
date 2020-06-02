class CreateMarineEcoregionsWorlds < ActiveRecord::Migration[6.0]
  def change
    create_table :marine_ecoregions_worlds do |t|
      t.integer :unep_fid, null: false
      t.string :region_type, null: false
      t.string :province, null: false
      t.string :ecoregion
      t.string :biome
      t.integer :trend_reg_id

      t.timestamps
    end
  end
end
