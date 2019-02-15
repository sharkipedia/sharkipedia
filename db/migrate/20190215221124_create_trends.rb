class CreateTrends < ActiveRecord::Migration[5.2]
  def change
    create_table :trends do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :data_source, foreign_key: true
      t.belongs_to :species, foreign_key: true
      t.belongs_to :location, foreign_key: true
      t.belongs_to :ocean, foreign_key: true
      t.belongs_to :data_type, foreign_key: true
      t.belongs_to :unit, foreign_key: true
      t.belongs_to :sampling_method, foreign_key: true
      t.integer :no_years
      t.integer :time_min
      t.text :taxonomic_notes
      t.string :page_and_figure_number
      t.string :line_used
      t.integer :pdf_page
      t.integer :actual_page
      t.string :depth
      t.string :model
      t.string :figure_name
      t.string :figure_data

      t.timestamps
    end
  end
end
