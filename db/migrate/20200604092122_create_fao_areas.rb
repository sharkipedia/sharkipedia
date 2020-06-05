class CreateFaoAreas < ActiveRecord::Migration[6.0]
  def change
    create_table :fao_areas do |t|
      t.string :f_code, null: false
      t.string :f_level, null: false
      t.belongs_to :ocean, null: false, foreign_key: true
      t.string :f_area
      t.string :f_subarea
      t.string :f_division
      t.string :f_subdivision
      t.string :f_subunit
      t.string :name, null: false

      t.timestamps
    end
    add_index :fao_areas, :f_code
  end
end
