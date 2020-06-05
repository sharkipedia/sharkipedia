class RemoveModelFieldFromTrends < ActiveRecord::Migration[6.0]
  def change
    remove_column :trends, :model, :string
  end
end
