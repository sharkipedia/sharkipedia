class CreateTrendObservations < ActiveRecord::Migration[5.2]
  def change
    create_table :trend_observations do |t|
      t.belongs_to :trend, foreign_key: true
      t.string :year, null: false
      t.string :value, null: false

      t.timestamps
    end
  end
end
