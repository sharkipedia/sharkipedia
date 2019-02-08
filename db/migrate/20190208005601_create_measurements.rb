class CreateMeasurements < ActiveRecord::Migration[5.2]
  def change
    create_table :measurements do |t|
      t.belongs_to :observation, foreign_key: true
      t.belongs_to :sex_type, foreign_key: true
      t.belongs_to :trait_class, foreign_key: true
      t.belongs_to :trait, foreign_key: true
      t.belongs_to :standard, foreign_key: true
      t.belongs_to :measurement_method, foreign_key: true
      t.belongs_to :measurement_model, foreign_key: true
      t.string :value
      t.belongs_to :value_type, foreign_key: true
      t.string :precision
      t.belongs_to :precision_type, foreign_key: true
      t.string :precision_upper
      t.integer :sample_size
      t.integer :dubious
      t.integer :validated
      t.string :validation_type
      t.text :notes
      t.string :depth
      t.string :contributor_id

      t.timestamps
    end
  end
end
