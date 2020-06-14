class CreateJoinTableTrendsFaoAreas < ActiveRecord::Migration[6.0]
  def change
    create_join_table :fao_areas, :trends do |t|
      t.index [:fao_area_id, :trend_id]
      t.index [:trend_id, :fao_area_id]
    end
  end
end
