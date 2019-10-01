class Measurement < ApplicationRecord
  belongs_to :observation
  belongs_to :longhurst_province, optional: true
  belongs_to :sex_type
  belongs_to :trait_class
  belongs_to :trait
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
    self.location = Location.find_or_create_by name: location.name
  end
end
