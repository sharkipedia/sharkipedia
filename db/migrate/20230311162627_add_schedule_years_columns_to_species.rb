class AddScheduleYearsColumnsToSpecies < ActiveRecord::Migration[7.0]
  def change
    add_column :species, :cms_status_year, :string
    add_column :species, :cites_status_year, :string
  end
end
