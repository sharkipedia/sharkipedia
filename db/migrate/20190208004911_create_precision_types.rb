class CreatePrecisionTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :precision_types do |t|
      t.string :name, unique: true, null: false
      t.text :description

      t.timestamps
    end
  end
end
