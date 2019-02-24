class ChangeTrendUnitToStandard < ActiveRecord::Migration[5.2]
  def change
    remove_reference :trends, :unit, index: true, foreign_key: true
    add_reference :trends, :standard, index: true, foreign_key: true
  end
end
