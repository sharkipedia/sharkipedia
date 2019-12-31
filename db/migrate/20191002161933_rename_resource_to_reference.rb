class RenameResourceToReference < ActiveRecord::Migration[6.0]
  def change
    remove_index :observations_resources, column: [:observation_id, :resource_id], name: "index_observations_resources_on_observation_id_and_resource_id"
    remove_index :observations_resources, column: [:resource_id, :observation_id], name: "index_observations_resources_on_resource_id_and_observation_id"
    rename_table :resources, :references
    rename_column :references, :resource, :reference
    rename_table :observations_resources, :observations_references
    rename_column :observations_references, :resource_id, :reference_id
    rename_column :trends, :resource_id, :reference_id
    add_index :observations_references, [:observation_id, :reference_id], name: "index_obser_refs_on_observation_id_and_reference_id"
    add_index :observations_references, [:reference_id, :observation_id], name: "index_obser_refs_on_reference_id_and_observation_id"
  end
end
