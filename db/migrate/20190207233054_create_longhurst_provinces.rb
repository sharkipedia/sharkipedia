class CreateLonghurstProvinces < ActiveRecord::Migration[5.2]
  def change
    create_table :longhurst_provinces do |t|
      t.string :name, presence: true
      t.string :code, presence: true, uniqueness: true, index: true

      t.timestamps
    end
  end
end
