require './lib/import_xlsx'

class Import < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :approved_by, class_name: 'User', optional: true

  validates :title, presence: true

  TYPES = %w( traits trends )
  validates_inclusion_of :import_type, in: TYPES

  has_one_attached :xlsx_file

  # Approval / Import state machine
  aasm do
    # A new XLSX file has been uploaded and needs to be reviewed by an editor
    state :pending_review, initial: true, after: :do_validate
    # The editor has decided that further changes are necessary before the
    # data can be imported.
    state :changes_requested
    # The editor has approved the data
    state :approved
    # The data was imported into the database
    state :imported, before_enter: :do_import
    # The editor has decided that the data is not appropriate for the database
    state :rejected
    # The data is publicly available
    state :published, before_enter: :do_publish

    event :request_changes do
      transitions from: [:pending_review], to: :changes_requested
    end

    event :resubmit do
      transitions from: [:changes_requested], to: :pending_review
    end

    event :approve do
      transitions from: [:pending_review], to: :approved
    end

    event :reject do
      transitions from: [:pending_review], to: :rejected
    end

    event :import do
      transitions from: [:approved], to: :imported
    end

    event :publish do
      transitions from: [:imported], to: :published
    end

    event :unpublish do
      transitions from: [:published], to: :imported
    end
  end

  def state
    aasm_state.humanize(capitalize: false)
  end

  def do_validate
  end

  def do_import
    # run the actual import
  end

  def do_publish
    # publish the imported data
  end

  def uploaded_by
    user.email
  end

  def self.import_types
    TYPES
  end
end
