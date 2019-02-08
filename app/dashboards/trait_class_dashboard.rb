require "administrate/base_dashboard"

class TraitClassDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    traits: Field::HasMany,
    standards: Field::HasMany,
    measurement_methods: Field::HasMany,
    measurement_models: Field::HasMany,
    id: Field::Number,
    name: Field::String,
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
    :traits,
    :standards,
    :measurement_methods,
    :measurement_models,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :traits,
    :standards,
    :measurement_methods,
    :measurement_models,
    :id,
    :name,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :traits,
    :standards,
    :measurement_methods,
    :measurement_models,
    :name,
  ].freeze

  # Overwrite this method to customize how trait classes are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(trait_class)
    trait_class.name
  end
end
