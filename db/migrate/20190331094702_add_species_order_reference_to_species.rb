class AddSpeciesOrderReferenceToSpecies < ActiveRecord::Migration[5.2]
  def change
    add_reference :species, :species_order, foreign_key: true
  end
end
