class CreateSourceObservations < ActiveRecord::Migration[6.0]
  def change
    create_table :source_observations do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
