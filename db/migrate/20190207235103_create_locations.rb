class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :name
      t.decimal :lat, precision: 15, scale: 10
      t.decimal :lon, precision: 15, scale: 10

      t.timestamps
    end
  end
end
