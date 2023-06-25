class CreateAuthorsReferencesJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :authors, :references do |t|
      t.index :author_id
      t.index :reference_id
    end
  end
end
