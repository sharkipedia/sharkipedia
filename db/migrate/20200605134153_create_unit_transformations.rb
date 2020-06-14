class CreateUnitTransformations < ActiveRecord::Migration[6.0]
  def change
    create_table :unit_transformations do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
