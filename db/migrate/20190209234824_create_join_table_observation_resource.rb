class CreateJoinTableObservationResource < ActiveRecord::Migration[5.2]
  def change
    create_join_table :observations, :resources do |t|
      t.index [:observation_id, :resource_id]
      t.index [:resource_id, :observation_id]
    end
  end
end
