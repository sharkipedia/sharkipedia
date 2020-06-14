class AddFreeformFieldToTrends < ActiveRecord::Migration[6.0]
  def change
    add_column :trends, :sampling_method_info, :string
    add_column :trends, :dataset_representativeness_experts, :string
    add_column :trends, :experts_for_representativeness, :string
  end
end
