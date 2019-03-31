require "administrate/base_dashboard"

class SpeciesDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    edge_scientific_name: Field::String,
    iucn_code: Field::String,
    species_subclass: Field::BelongsTo,
    species_superorder: Field::BelongsTo,
    species_order: Field::BelongsTo,
    species_family: Field::BelongsTo,
    species_data_type: Field::BelongsTo,
    observations: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :edge_scientific_name,
    :species_superorder,
    :observations,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :name,
    :edge_scientific_name,
    :species_subclass,
    :species_superorder,
    :species_order,
    :species_family,
    :species_data_type,
    :iucn_code,
    :observations,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :edge_scientific_name,
    :species_subclass,
    :species_superorder,
    :species_order,
    :species_family,
    :species_data_type,
    :iucn_code,
    :species_superorder,
  ].freeze

  # Overwrite this method to customize how species are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(species)
    species.name
  end
end
