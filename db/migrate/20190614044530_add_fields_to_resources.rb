class AddFieldsToResources < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :suffix, :string
    add_column :resources, :author_year, :string
    add_column :resources, :resource, :string
  end
end
