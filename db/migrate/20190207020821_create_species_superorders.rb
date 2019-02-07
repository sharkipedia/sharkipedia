class CreateSpeciesSuperorders < ActiveRecord::Migration[5.2]
  def change
    create_table :species_superorders do |t|
      t.string :name, unique: true, null: false

      t.timestamps
    end
  end
end
