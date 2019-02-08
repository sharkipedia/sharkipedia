class CreateTraitClasses < ActiveRecord::Migration[5.2]
  def change
    create_table :trait_classes do |t|
      t.string :name, unique: true, null: false

      t.timestamps
    end
  end
end
