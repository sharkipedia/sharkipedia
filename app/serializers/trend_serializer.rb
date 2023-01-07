# == Schema Information
#
# Table name: trends
#
#  id                                 :bigint           not null, primary key
#  actual_page                        :integer
#  comments                           :text
#  data_mined                         :boolean
#  dataset_map                        :boolean
#  dataset_representativeness_experts :string
#  depth                              :string
#  end_year                           :integer
#  experts_for_representativeness     :string
#  figure_data                        :string
#  figure_name                        :string
#  line_used                          :string
#  no_years                           :integer
#  page_and_figure_number             :string
#  pdf_page                           :integer
#  sampling_method_info               :string
#  start_year                         :integer
#  time_min                           :integer
#  unit_freeform                      :text
#  variance                           :boolean
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  analysis_model_id                  :bigint
#  data_type_id                       :bigint
#  import_id                          :bigint
#  location_id                        :bigint
#  reference_id                       :bigint
#  sampling_method_id                 :bigint
#  species_group_id                   :bigint
#  species_id                         :bigint
#  standard_id                        :bigint
#  unit_gear_id                       :bigint
#  unit_spatial_id                    :bigint
#  unit_time_id                       :bigint
#  unit_transformation_id             :bigint
#  user_id                            :bigint
#
# Indexes
#
#  index_trends_on_analysis_model_id       (analysis_model_id)
#  index_trends_on_data_type_id            (data_type_id)
#  index_trends_on_import_id               (import_id)
#  index_trends_on_location_id             (location_id)
#  index_trends_on_reference_id            (reference_id)
#  index_trends_on_sampling_method_id      (sampling_method_id)
#  index_trends_on_species_group_id        (species_group_id)
#  index_trends_on_species_id              (species_id)
#  index_trends_on_standard_id             (standard_id)
#  index_trends_on_unit_gear_id            (unit_gear_id)
#  index_trends_on_unit_spatial_id         (unit_spatial_id)
#  index_trends_on_unit_time_id            (unit_time_id)
#  index_trends_on_unit_transformation_id  (unit_transformation_id)
#  index_trends_on_user_id                 (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (analysis_model_id => analysis_models.id)
#  fk_rails_...  (data_type_id => data_types.id)
#  fk_rails_...  (import_id => imports.id)
#  fk_rails_...  (location_id => locations.id)
#  fk_rails_...  (reference_id => "references".id)
#  fk_rails_...  (sampling_method_id => sampling_methods.id)
#  fk_rails_...  (species_group_id => species_groups.id)
#  fk_rails_...  (species_id => species.id)
#  fk_rails_...  (standard_id => standards.id)
#  fk_rails_...  (unit_gear_id => unit_gears.id)
#  fk_rails_...  (unit_spatial_id => unit_spatials.id)
#  fk_rails_...  (unit_time_id => unit_times.id)
#  fk_rails_...  (unit_transformation_id => unit_transformations.id)
#  fk_rails_...  (user_id => users.id)
#
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
