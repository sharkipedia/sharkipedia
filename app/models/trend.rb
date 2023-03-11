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
class Trend < ApplicationRecord
  belongs_to :user
  belongs_to :import
  belongs_to :reference
  belongs_to :species, optional: true
  belongs_to :species_group, optional: true
  belongs_to :location
  belongs_to :data_type
  belongs_to :sampling_method
  belongs_to :standard
  belongs_to :unit_time, optional: true
  belongs_to :unit_spatial, optional: true
  belongs_to :unit_gear, optional: true
  belongs_to :unit_transformation, optional: true
  belongs_to :analysis_model, optional: true

  accepts_nested_attributes_for :location, allow_destroy: true
  before_save :find_or_create_location

  has_many :trend_observations, -> { order(:year) }, dependent: :destroy
  has_and_belongs_to_many :source_observations
  has_and_belongs_to_many :marine_ecoregions_worlds
  has_and_belongs_to_many :fao_areas
  has_and_belongs_to_many :oceans

  has_one_attached :figure

  validates :start_year, presence: true
  validates :end_year, presence: true

  validate :species_or_species_group

  filterrific(
    default_filter_params: {},
    available_filters: [
      :search_family,
      :search_name,
      :search_author_year,
      :search_source_observation,
      :search_data_type,
      :search_unit,
      :search_location,
      :search_oceans
    ]
  )

  scope :search_family, ->(name) {
    joins(species: :species_family).where("species_families.name ILIKE ?", "%#{name}%")
  }

  scope :search_name, ->(name) {
    found_species = Species.where("species.name ILIKE ?", "%#{name}%")

    where(species_group: SpeciesGroup.joins(:species).where("species.id": found_species))
      .or(Trend.where(species: found_species))
  }

  scope :search_species_groups, ->(name) {
    joins(species_group: :species).where("species.name ILIKE ?", "%#{name}%")
  }

  scope :search_species, ->(name) {
  }

  scope :search_author_year, ->(name) {
    where(reference: Reference.where("name ILIKE ?", "%#{name}%"))
  }

  scope :search_unit, ->(name) {
    joins(:standard).where("standards.name ILIKE ?", "%#{name}%")
  }

  scope :search_data_type, ->(name) {
    joins(:data_type).where("data_types.name ILIKE ?", "%#{name}%")
  }

  scope :search_source_observation, ->(name) {
    joins(:source_observations).where("source_observations.name ILIKE ?", "%#{name}%")
  }

  scope :search_location, ->(name) {
    joins(:location).where("locations.name ILIKE ?", "%#{name}%")
  }

  scope :search_oceans, ->(name) {
    joins(:oceans).where("oceans.name ILIKE ?", "%#{name}%")
  }

  def species_or_species_group
    if species.blank? && species_group.blank?
      errors.add(:species_id, "species or species_group must be set")
      errors.add(:species_group_id, "species or species_group must be set")
    end
  end

  def title
    "#{(species || species_group).name} - #{reference.name}"
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << %w[year value]
      observations_data.each do |data_pair|
        csv << data_pair
      end
    end
  end

  def observations_data
    trend_observations.map do |trend_observation|
      [trend_observation.year, trend_observation.value]
    end
  end

  def create_or_update_observations observations
    incoming_years = observations.map(&:first)
    existing = trend_observations.map(&:year)
    to_remove = existing - incoming_years

    trend_observations.where(year: to_remove).destroy_all

    observations.each do |year, value|
      observation = trend_observations.where(year:).first
      if observation
        observation.update(value:)
      else
        trend_observations.create(year:, value:)
      end
    end
  end

  def combined_unit
    [
      standard.name,
      unit_time&.name,
      unit_spatial&.name,
      unit_gear&.name
    ].reject { |u| u.blank? || u == "NA" }.join(" per ")
  end

  def ppow_region_ids
    marine_ecoregions_worlds.ppow.map(&:id)
  end

  def meow_region_ids
    marine_ecoregions_worlds.meow.map(&:id)
  end

  private

  def find_or_create_location
    unless location.persisted?
      self.location = Location.find_or_create_by name: location.name,
        lat: location.lat,
        lon: location.lon
    end
  end
end
