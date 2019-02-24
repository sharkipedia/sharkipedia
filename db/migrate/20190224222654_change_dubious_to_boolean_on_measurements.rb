class ChangeDubiousToBooleanOnMeasurements < ActiveRecord::Migration[5.2]
  def change
    change_column :measurements, :dubious, 'boolean USING CAST(dubious AS boolean)'
  end
end
