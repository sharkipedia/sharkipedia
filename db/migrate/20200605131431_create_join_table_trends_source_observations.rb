class CreateJoinTableTrendsSourceObservations < ActiveRecord::Migration[6.0]
  def change
    create_join_table :trends, :source_observations do |t|
      t.index [:trend_id, :source_observation_id], name: "trends_source_observations_index"
      t.index [:source_observation_id, :trend_id], name: "source_observations_trends_index"
    end
  end
end
