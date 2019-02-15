class CreateDataSources < ActiveRecord::Migration[5.2]
  def change
    create_table :data_sources do |t|
      t.string :name, unique: true, null: false
      t.string :year, null: false
      t.string :author_year

      t.timestamps
    end
  end
end
