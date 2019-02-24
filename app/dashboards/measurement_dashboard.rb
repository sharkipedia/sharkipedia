require "administrate/base_dashboard"

class MeasurementDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    observation: Field::BelongsTo,
    sex_type: Field::BelongsTo,
    trait_class: Field::BelongsTo,
    trait: Field::BelongsTo,
    standard: Field::BelongsTo,
    measurement_method: Field::BelongsTo,
    measurement_model: Field::BelongsTo,
    value_type: Field::BelongsTo,
    precision_type: Field::BelongsTo,
    id: Field::Number,
    value: Field::String,
    precision: Field::String,
    precision_upper: Field::String,
    sample_size: Field::Number,
    dubious: Field::Number,
    validated: Field::Number,
    validation_type: Field::String,
    notes: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :observation,
    :sex_type,
    :trait_class,
    :trait,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :observation,
    :sex_type,
    :trait_class,
    :trait,
    :standard,
    :measurement_method,
    :measurement_model,
    :value_type,
    :precision_type,
    :id,
    :value,
    :precision,
    :precision_upper,
    :sample_size,
    :dubious,
    :validated,
    :validation_type,
    :notes,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :observation,
    :sex_type,
    :trait_class,
    :trait,
    :standard,
    :measurement_method,
    :measurement_model,
    :value_type,
    :precision_type,
    :value,
    :precision,
    :precision_upper,
    :sample_size,
    :dubious,
    :validated,
    :validation_type,
    :notes,
  ].freeze

  # Overwrite this method to customize how measurements are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(measurement)
  #   "Measurement ##{measurement.id}"
  # end
end
