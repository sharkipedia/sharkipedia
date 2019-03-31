class AddSpeciesSubclassReferenceToSpeciesSuperorder < ActiveRecord::Migration[5.2]
  def change
    add_reference :species_superorders, :species_subclass, foreign_key: true
  end
end
