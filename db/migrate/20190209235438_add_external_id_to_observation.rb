class AddExternalIdToObservation < ActiveRecord::Migration[5.2]
  def change
    add_column :observations, :external_id, :integer
    add_index :observations, :external_id
  end
end
