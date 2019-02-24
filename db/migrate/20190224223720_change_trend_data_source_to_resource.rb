class ChangeTrendDataSourceToResource < ActiveRecord::Migration[5.2]
  def change
    remove_reference :trends, :data_source, index: true, foreign_key: true
    add_reference :trends, :resource, index: true, foreign_key: true
  end
end
