class AddSpeciesSubclassReferenceToSpecies < ActiveRecord::Migration[5.2]
  def change
    add_reference :species, :species_subclass, foreign_key: true
  end
end
