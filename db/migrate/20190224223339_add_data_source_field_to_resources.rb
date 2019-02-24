class AddDataSourceFieldToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :data_source, :string
  end
end
