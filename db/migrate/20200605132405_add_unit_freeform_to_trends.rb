class AddUnitFreeformToTrends < ActiveRecord::Migration[6.0]
  def change
    add_column :trends, :unit_freeform, :text
  end
end
