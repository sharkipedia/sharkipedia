require "administrate/base_dashboard"

class ObservationDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    references: Field::HasMany,
    species: Field::BelongsTo,
    measurements: Field::HasMany,
    id: Field::Number,
    contributor_id: Field::String,
    access: Field::String,
    hidden: Field::Boolean,
    depth: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :contributor_id,
    :references,
    :species,
    :measurements,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :contributor_id,
    :references,
    :species,
    :measurements,
    :depth,
    :id,
    :access,
    :hidden,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :contributor_id,
    :references,
    :species,
    :measurements,
    :access,
    :hidden,
    :depth,
  ].freeze

  # Overwrite this method to customize how observations are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(observation)
    "#{observation.contributor_id} (#{observation.references.first.name})"
  end
end
