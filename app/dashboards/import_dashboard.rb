require "administrate/base_dashboard"

class ImportDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    approved_by: Field::BelongsTo.with_options(class_name: "User"),
    id: Field::Number,
    title: Field::String,
    import_type: Field::String,
    approved: Field::Boolean,
    approved_by_id: Field::Number,
    log: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    aasm_state: Field::String,
    xlsx_valid: Field::Boolean,
    reason: Field::Text,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :title,
    :user,
    :approved_by,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :approved_by,
    :id,
    :title,
    :import_type,
    :approved,
    :approved_by_id,
    :log,
    :created_at,
    :updated_at,
    :aasm_state,
    :xlsx_valid,
    :reason,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :approved_by,
    :title,
    :import_type,
    :approved,
    :approved_by_id,
    :log,
    :aasm_state,
    :xlsx_valid,
    :reason,
  ].freeze

  # Overwrite this method to customize how imports are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(import)
  #   "Import ##{import.id}"
  # end
end
