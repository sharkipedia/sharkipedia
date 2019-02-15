class CreateSamplingMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :sampling_methods do |t|
      t.string :name, unique: true, null: false
      t.string :code

      t.timestamps
    end
  end
end
