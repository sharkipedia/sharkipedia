class RemoveValidationTypeFieldFromMeasurement < ActiveRecord::Migration[5.2]
  def change
    remove_column :measurements, :validation_type
  end
end
