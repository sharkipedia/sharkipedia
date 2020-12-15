class TrendSerializer < BaseSerializer
  attribute :location do |object|
    object.location&.name
  end
  attribute :data_type do |object|
    object.data_type&.name
  end
  attribute :sampling_method do |object|
    object.sampling_method&.name
  end
  attribute :no_years
  attribute :time_min
  attribute :comments
  attribute :page_and_figure_number
  attribute :line_used
  attribute :pdf_page
  attribute :actual_page
  attribute :depth
  attribute :figure_name
  attribute :figure_data
  attribute :reference do |object|
    object.reference&.name
  end
  attribute :standard do |object|
    object.standard&.name
  end
  attribute :start_year
  attribute :end_year
  attribute :species_group do |object|
    object.species_group&.name
  end
  attribute :unit_freeform
  attribute :sampling_method_info
  attribute :dataset_representativeness_experts
  attribute :experts_for_representativeness
  attribute :dataset_map
  attribute :variance
  attribute :data_mined
  attribute :unit_time do |object|
    object.unit_time&.name
  end
  attribute :unit_spatial do |object|
    object.unit_spatial&.name
  end
  attribute :unit_gear do |object|
    object.unit_gear&.name
  end
  attribute :unit_transformation do |object|
    object.unit_transformation&.name
  end
  attribute :analysis_model do |object|
    object.analysis_model&.name
  end
  attribute :oceans do |object|
    object.oceans.map(&:name)
  end

  belongs_to :species

  has_many :trend_observations
end
