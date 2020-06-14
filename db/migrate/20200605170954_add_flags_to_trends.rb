class AddFlagsToTrends < ActiveRecord::Migration[6.0]
  def change
    add_column :trends, :dataset_map, :boolean
    add_column :trends, :variance, :boolean
    add_column :trends, :data_mined, :boolean
  end
end
