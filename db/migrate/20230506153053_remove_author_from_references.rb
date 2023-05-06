class RemoveAuthorFromReferences < ActiveRecord::Migration[7.0]
  def change
    remove_column :references, :author
  end
end
