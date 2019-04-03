class AddSourceYearToResource < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :year, :string
  end
end
