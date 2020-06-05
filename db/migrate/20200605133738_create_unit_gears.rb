class CreateUnitGears < ActiveRecord::Migration[6.0]
  def change
    create_table :unit_gears do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
