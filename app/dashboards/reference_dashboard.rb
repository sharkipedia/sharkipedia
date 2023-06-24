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
    title: Field::String,
    journal: Field::String,
    volume: Field::String,
    issue: Field::String,
    part_supplement: Field::String,
    pages: Field::String,
    start_page: Field::Number,
    errata: Field::String,
    epub_date: Field::Date,
    date: Field::Date,
    author: Field::Text,
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
    :title,
    :name,
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
    :observations,
    :title,
    :journal,
    :volume,
    :issue,
    :part_supplement,
    :pages,
    :start_page,
    :errata,
    :epub_date,
    :date,
    :author
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
    :file_public,
    :title,
    :journal,
    :volume,
    :issue,
    :part_supplement,
    :pages,
    :start_page,
    :errata,
    :epub_date,
    :date,
    :author
  ].freeze

  # Overwrite this method to customize how references are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(reference)
    reference.name
  end
end
