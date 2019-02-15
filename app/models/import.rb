class Import < ApplicationRecord
  TYPES = %w( traits trends )

  # TODO: state machine for imports
  # When a user creates a new import (i.e. uploads a new XLSX file) it is
  # `pending_review` and needs to be reviewed by an editor.
  #
  # An editor can then do one of the following: 
  # - `approve` the import which actually imports the
  #   data into the database, or they can 
  # - `request edits` to signal the uploading use that the data needs further
  #   attention before it can be edited. this should be accompanied by detailed
  #   notes.
  # - `reject` the import. this signifies that the data is not appropriate for
  #   the database and will not be accepted in this form. if the user wishes to
  #   attempt again they need to create a new import.
  #
  # when edits are requested the user can re-submit the uplaod which puts the
  # import back into the `pending_review state`
  # STATES = %w( pending_review edits_requested rejected approved )

  # TODO: add automatic validation of the XLSX file
  # sort of a dry run of the xlsx import script to see if an import would work
  # - this could render out the hypothetically created objects and draw up
  #   their relationships

  belongs_to :user
  belongs_to :approved_by, class_name: 'User', optional: true

  validates :title, presence: true
  validates_inclusion_of :import_type, in: TYPES

  has_one_attached :xlsx_file

  def uploaded_by
    user.email
  end

  def self.import_types
    TYPES
  end
end
