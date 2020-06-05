class CreateUnitSpatials < ActiveRecord::Migration[6.0]
  def change
    create_table :unit_spatials do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
