class AddDepthToObservation < ActiveRecord::Migration[5.2]
  def change
    add_column :observations, :depth, :string
  end
end
