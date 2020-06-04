class CreateJoinTableSpeciesSpeciesGroups < ActiveRecord::Migration[6.0]
  def change
    create_join_table :species, :species_groups do |t|
      t.index [:species_id, :species_group_id]
      t.index [:species_group_id, :species_id]
    end
  end
end
