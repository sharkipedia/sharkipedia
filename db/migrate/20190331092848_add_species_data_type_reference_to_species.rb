class AddSpeciesDataTypeReferenceToSpecies < ActiveRecord::Migration[5.2]
  def change
    add_reference :species, :species_data_type, foreign_key: true
  end
end
