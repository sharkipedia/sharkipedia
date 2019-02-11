class RemoveResourceReferencesFromObservation < ActiveRecord::Migration[5.2]
  def change
    change_table :observations do |t|
      t.remove_references :resource
      t.remove_references :secondary_resource
    end
  end
end
