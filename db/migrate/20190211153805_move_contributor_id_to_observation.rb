class MoveContributorIdToObservation < ActiveRecord::Migration[5.2]
  def change
    remove_column :measurements, :contributor_id, :string
    add_column :observations, :contributor_id, :string
  end
end
