class CreateDataTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :data_types do |t|
      t.string :name, unique: true, null: false

      t.timestamps
    end
  end
end
