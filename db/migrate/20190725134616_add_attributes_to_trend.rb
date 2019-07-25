class AddAttributesToTrend < ActiveRecord::Migration[6.0]
  def change
    add_column :trends, :start_year, :integer
    add_column :trends, :end_year, :integer
  end
end
