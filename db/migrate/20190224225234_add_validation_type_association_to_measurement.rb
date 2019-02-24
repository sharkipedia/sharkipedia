class AddValidationTypeAssociationToMeasurement < ActiveRecord::Migration[5.2]
  def change
    add_reference :measurements, :validation_type, foreign_key: true
  end
end
