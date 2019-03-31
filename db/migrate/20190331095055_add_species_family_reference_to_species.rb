class AddSpeciesFamilyReferenceToSpecies < ActiveRecord::Migration[5.2]
  def change
    add_reference :species, :species_family, foreign_key: true
  end
end
