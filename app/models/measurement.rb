# == Schema Information
#
# Table name: measurements
#
#  id                    :bigint           not null, primary key
#  date                  :string
#  dubious               :boolean
#  notes                 :text
#  precision             :string
#  precision_upper       :string
#  sample_size           :integer
#  validated             :integer
#  value                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  location_id           :bigint           not null
#  longhurst_province_id :bigint
#  measurement_method_id :bigint
#  measurement_model_id  :bigint
#  observation_id        :bigint
#  precision_type_id     :bigint
#  sex_type_id           :bigint
#  species_id            :bigint           not null
#  standard_id           :bigint
#  trait_class_id        :bigint
#  trait_id              :bigint
#  validation_type_id    :bigint
#  value_type_id         :bigint
#
# Indexes
#
#  index_measurements_on_location_id            (location_id)
#  index_measurements_on_longhurst_province_id  (longhurst_province_id)
#  index_measurements_on_measurement_method_id  (measurement_method_id)
#  index_measurements_on_measurement_model_id   (measurement_model_id)
#  index_measurements_on_observation_id         (observation_id)
#  index_measurements_on_precision_type_id      (precision_type_id)
#  index_measurements_on_sex_type_id            (sex_type_id)
#  index_measurements_on_species_id             (species_id)
#  index_measurements_on_standard_id            (standard_id)
#  index_measurements_on_trait_class_id         (trait_class_id)
#  index_measurements_on_trait_id               (trait_id)
#  index_measurements_on_validation_type_id     (validation_type_id)
#  index_measurements_on_value_type_id          (value_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#  fk_rails_...  (longhurst_province_id => longhurst_provinces.id)
#  fk_rails_...  (measurement_method_id => measurement_methods.id)
#  fk_rails_...  (measurement_model_id => measurement_models.id)
#  fk_rails_...  (observation_id => observations.id)
#  fk_rails_...  (precision_type_id => precision_types.id)
#  fk_rails_...  (sex_type_id => sex_types.id)
#  fk_rails_...  (species_id => species.id)
#  fk_rails_...  (standard_id => standards.id)
#  fk_rails_...  (trait_class_id => trait_classes.id)
#  fk_rails_...  (trait_id => traits.id)
#  fk_rails_...  (validation_type_id => validation_types.id)
#  fk_rails_...  (value_type_id => value_types.id)
#
class Measurement < ApplicationRecord
  belongs_to :observation
  belongs_to :species
  belongs_to :longhurst_province, optional: true
  belongs_to :sex_type
  belongs_to :trait
  has_one :trait_class, through: :trait
  belongs_to :standard, optional: true
  belongs_to :measurement_method, optional: true
  belongs_to :measurement_model, optional: true
  belongs_to :value_type, optional: true
  belongs_to :validation_type, optional: true
  belongs_to :precision_type, optional: true

  belongs_to :location
  accepts_nested_attributes_for :location, allow_destroy: true

  before_save :find_or_create_location

  private

  def find_or_create_location
    unless location.persisted?
      self.location = Location.find_or_create_by name: location.name,
        lat: location.lat,
        lon: location.lon
    end
  end
end
