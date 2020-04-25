class AddBelongsToImportToTrend < ActiveRecord::Migration[6.0]
  def change
    add_reference :trends, :import, null: true, foreign_key: true
  end
end
