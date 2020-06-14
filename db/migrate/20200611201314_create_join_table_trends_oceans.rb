class CreateJoinTableTrendsOceans < ActiveRecord::Migration[6.0]
  def change
    create_join_table :trends, :oceans do |t|
      t.index [:trend_id, :ocean_id]
      t.index [:ocean_id, :trend_id]
    end
  end
end
