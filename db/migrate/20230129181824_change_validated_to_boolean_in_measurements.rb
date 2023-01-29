class ChangeValidatedToBooleanInMeasurements < ActiveRecord::Migration[7.0]
  def up
    change_column :measurements, :validated, :boolean
  end

  def down
    change_column :measurements, :validated, :integer
  end
end
