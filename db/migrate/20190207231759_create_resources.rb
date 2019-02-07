class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources do |t|
      t.string :name, unique: true, null: false
      t.string :doi, unique: true, null: false

      t.timestamps
    end
  end
end
