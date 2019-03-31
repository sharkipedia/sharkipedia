class AddFieldsToSpecies < ActiveRecord::Migration[5.2]
  def change
    add_column :species, :edge_scientific_name, :string
    add_column :species, :scientific_name, :string
    add_column :species, :authorship, :string
  end
end
