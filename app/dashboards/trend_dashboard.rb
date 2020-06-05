require "administrate/base_dashboard"

class TrendDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    species: Field::BelongsTo,
    location: Field::BelongsTo,
    ocean: Field::BelongsTo,
    data_type: Field::BelongsTo,
    standard: Field::BelongsTo,
    unit_time: Field::BelongsTo,
    unit_spatial: Field::BelongsTo,
    unit_gear: Field::BelongsTo,
    unit_transformation: Field::BelongsTo,
    unit_freeform: Field::Text,
    sampling_method: Field::BelongsTo,
    id: Field::Number,
    no_years: Field::Number,
    time_min: Field::Number,
    comments: Field::Text,
    page_and_figure_number: Field::String,
    line_used: Field::String,
    pdf_page: Field::Number,
    actual_page: Field::Number,
    depth: Field::String,
    analysis_model: Field::BelongsTo,
    trend_observations: Field::HasMany,
    figure_name: Field::String,
    figure_data: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :user,
    :species,
    :location
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :species,
    :location,
    :ocean,
    :data_type,
    :standard,
    :sampling_method,
    :id,
    :no_years,
    :time_min,
    :comments,
    :page_and_figure_number,
    :line_used,
    :pdf_page,
    :actual_page,
    :depth,
    :analysis_model,
    :figure_name,
    :trend_observations,
    :figure_data,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :species,
    :location,
    :ocean,
    :data_type,
    :standard,
    :sampling_method,
    :no_years,
    :time_min,
    :comments,
    :page_and_figure_number,
    :line_used,
    :pdf_page,
    :actual_page,
    :depth,
    :analysis_model,
    :figure_name,
    :figure_data
  ].freeze

  # Overwrite this method to customize how trends are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(trend)
  #   "Trend ##{trend.id}"
  # end
end
