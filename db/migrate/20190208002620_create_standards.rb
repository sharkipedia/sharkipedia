class CreateStandards < ActiveRecord::Migration[5.2]
  def change
    create_table :standards do |t|
      t.string :name, null: false
      t.text :description
      t.belongs_to :trait_class, foreign_key: true

      t.timestamps
    end
  end
end
