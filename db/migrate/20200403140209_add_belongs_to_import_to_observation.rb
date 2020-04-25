class AddBelongsToImportToObservation < ActiveRecord::Migration[6.0]
  def change
    add_reference :observations, :import, null: true, foreign_key: true
  end
end
