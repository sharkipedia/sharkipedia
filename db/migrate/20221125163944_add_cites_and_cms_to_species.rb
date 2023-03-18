class AddCitesAndCmsToSpecies < ActiveRecord::Migration[6.1]
  def change
    add_column :species, :cites_status, :integer, default: 0
    add_column :species, :cms_status, :integer, default: 0
  end
end
