class CreateValueTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :value_types do |t|
      t.string :name, unique: true, null: false
      t.text :description

      t.timestamps
    end
  end
end
