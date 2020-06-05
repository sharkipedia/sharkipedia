class AddSpeciesGroupReferenceToTrend < ActiveRecord::Migration[6.0]
  def change
    add_reference :trends, :species_group, foreign_key: true
  end
end
