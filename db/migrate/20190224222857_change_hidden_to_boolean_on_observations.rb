class ChangeHiddenToBooleanOnObservations < ActiveRecord::Migration[5.2]
  def change
    change_column :observations, :hidden, 'boolean USING CAST(hidden AS boolean)'
  end
end
