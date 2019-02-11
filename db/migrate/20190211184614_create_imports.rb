class CreateImports < ActiveRecord::Migration[5.2]
  def change
    create_table :imports do |t|
      t.string :title, null: false
      t.string :import_type, null: false
      t.belongs_to :user, foreign_key: true
      t.boolean :approved
      t.references :approved_by, index: true, foreign_key: {to_table: :users}
      t.text :log

      t.timestamps
    end
  end
end
