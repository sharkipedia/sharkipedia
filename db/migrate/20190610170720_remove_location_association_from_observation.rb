class RemoveLocationAssociationFromObservation < ActiveRecord::Migration[6.0]
  def change
    remove_reference :observations, :location, null: false, foreign_key: true
  end
end
