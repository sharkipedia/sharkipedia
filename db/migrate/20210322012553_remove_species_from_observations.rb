class RemoveSpeciesFromObservations < ActiveRecord::Migration[6.1]
  def change
    remove_reference :observations, :species, null: false, foreign_key: true
  end
end
