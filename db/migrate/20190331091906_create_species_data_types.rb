class CreateSpeciesDataTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :species_data_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
