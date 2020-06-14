class RemoveOceanReferenceFromTrends < ActiveRecord::Migration[6.0]
  def change
    remove_reference :trends, :ocean, null: false, foreign_key: true
  end
end
