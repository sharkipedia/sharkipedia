class RemoveDepthFromMeasurement < ActiveRecord::Migration[5.2]
  def change
    remove_column :measurements, :depth, :integer
  end
end
