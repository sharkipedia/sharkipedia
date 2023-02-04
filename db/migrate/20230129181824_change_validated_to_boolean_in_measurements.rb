class ChangeValidatedToBooleanInMeasurements < ActiveRecord::Migration[7.0]
  def up
    change_column :measurements, :validated, "boolean USING CAST(validated AS boolean)"
    Measurement.where(validated: nil).update_all(validated: false)
    change_column_null :measurements, :validated, false, false
  end

  def down
    change_column :measurements, :validated, "integer USING CAST(validated AS integer)"
    change_column_null :measurements, :validated, true, nil
  end
end
