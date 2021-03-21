class AddIndexOnReferencesName < ActiveRecord::Migration[6.1]
  def change
    add_index :references, :name, unique: true
  end
end
