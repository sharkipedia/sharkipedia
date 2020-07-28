class RemoveFieldsFromMarineEcoregionsWorld < ActiveRecord::Migration[6.0]
  def change
    remove_column :marine_ecoregions_worlds, :unep_fid, :integer
    remove_column :marine_ecoregions_worlds, :ecoregion, :string
    remove_column :marine_ecoregions_worlds, :biome, :string
  end
end
