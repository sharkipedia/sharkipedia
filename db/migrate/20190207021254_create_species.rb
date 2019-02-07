class CreateSpecies < ActiveRecord::Migration[5.2]
  def change
    create_table :species do |t|
      t.string :name, unique: true, null: false
      t.string :iucn_code, unique: true
      t.belongs_to :species_superorder

      t.timestamps
    end
  end
end
