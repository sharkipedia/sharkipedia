class CreateObservations < ActiveRecord::Migration[5.2]
  def change
    create_table :observations do |t|
      t.belongs_to :resource, foreign_key: true
      t.references :secondary_resource
      t.belongs_to :species, foreign_key: true
      t.belongs_to :longhurst_province, foreign_key: true
      t.string :date
      t.string :access
      t.integer :hidden
      t.belongs_to :user, foreign_key: true
      t.belongs_to :location, foreign_key: true

      t.timestamps
    end
  end
end
