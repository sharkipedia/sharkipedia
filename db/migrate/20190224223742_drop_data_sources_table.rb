class DropDataSourcesTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :data_sources
  end
end
