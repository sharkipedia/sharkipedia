require "administrate/base_dashboard"

class ReferenceDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    doi: Field::String,
    year: Field::String,
    suffix: Field::String,
    data_source: Field::String,
    reference: Field::String,
    file_public: Field::Boolean,
    observations: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :doi,
    :data_source,
    :observations
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :doi,
    :data_source,
    :year,
    :suffix,
    :reference,
    :file_public,
    :observations
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :doi,
    :data_source,
    :year,
    :suffix,
    :reference,
    :file_public
  ].freeze

  # Overwrite this method to customize how references are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(reference)
    "Reference #{reference.name}"
  end
end
