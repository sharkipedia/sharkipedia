class AddLocationReferenceToMeasurement < ActiveRecord::Migration[6.0]
  def change
    add_reference :measurements, :location, null: false, foreign_key: true
  end
end
