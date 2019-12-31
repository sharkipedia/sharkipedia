class AddSlugToSpecies < ActiveRecord::Migration[6.0]
  def up
    add_column :species, :slug, :string
    add_index :species, :slug

    Species.find_each(&:save)

    change_column_null :species, :slug, false
  end

  def down
    remove_column :species, :slug
  end
end
