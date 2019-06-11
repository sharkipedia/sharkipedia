class AddLonghursProvinceReferenceToMeasurement < ActiveRecord::Migration[6.0]
  def change
    add_reference :measurements, :longhurst_province, foreign_key: true
  end
end
