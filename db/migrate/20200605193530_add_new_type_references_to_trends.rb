class AddNewTypeReferencesToTrends < ActiveRecord::Migration[6.0]
  def change
    add_reference :trends, :unit_time, foreign_key: true
    add_reference :trends, :unit_spatial, foreign_key: true
    add_reference :trends, :unit_gear, foreign_key: true
    add_reference :trends, :unit_transformation, foreign_key: true
    add_reference :trends, :analysis_model, foreign_key: true
  end
end
