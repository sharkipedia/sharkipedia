class CreateSpeciesOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :species_orders do |t|
      t.string :name
      t.belongs_to :species_superorder, foreign_key: true
      t.belongs_to :species_subclass, foreign_key: true

      t.timestamps
    end
  end
end
