require './lib/import_xlsx'

class Import < ApplicationRecord
  include AASM
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :approved_by, class_name: 'User', optional: true

  validates :title, presence: true

  TYPES = %w( traits trends )
  validates_inclusion_of :import_type, in: TYPES

  has_one_attached :xlsx_file

  # Approval / Import state machine
  aasm do
    # A new XLSX file has been uploaded
    state :uploaded, initial: true
    # needs to be reviewed by an editor
    state :pending_review
    # The editor has decided that further changes are necessary before the
    # data can be imported.
    state :changes_requested
    # The editor has approved the data
    state :approved
    # The data was imported into the database
    state :imported
    # The editor has decided that the data is not appropriate for the database
    state :rejected
    # The data is publicly available
    state :published, before_enter: :do_publish

    event :validate_upload do
      transitions from: [:uploaded], to: :pending_review
    end

    event :request_changes do
      transitions from: [:pending_review, :uploaded], to: :changes_requested
    end

    event :resubmit do
      transitions from: [:changes_requested], to: :pending_review
    end

    event :approve, after_commit: :queue_import do
      transitions from: [:pending_review], to: :approved,
                  guard: :xlsx_valid?
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
    puts "triggered #{self.inspect}"
    url = Rails.application.routes.url_helpers.rails_blob_url xlsx_file

    # TODO: automatically detect the file type from the XLSX
    # i.e. if it's a trend or traits import
    i = case self.import_type
          when 'traits'
            ImportXlsx::Traits.new url
          when 'trends'
            ImportXlsx::Trends.new url
          end

    i.validate

    self.log = i.log
    self.xlsx_valid = i.valid
    self.save!

    if xlsx_valid
      self.validate_upload!
    else
      self.request_changes!
    end

    # TODO: send email to uploader
  end

  def queue_import
    ImportJob.perform_later self
  end

  def do_import
    url = Rails.application.routes.url_helpers.rails_blob_url xlsx_file

    # TODO: automatically detect the file type from the XLSX
    # i.e. if it's a trend or traits import
    i = case self.import_type
          when 'traits'
            ImportXlsx::Traits.new url
          when 'trends'
            ImportXlsx::Trends.new url
          end

    # TODO: handle import failure
    self.import! if i.import
    self.log += "\n" + i.log
    self.save!

    # TODO: send email to uploader
  end

  def do_publish
    # publish the imported data
  end

  def uploaded_by
    user.email
  end

  def xlsx_valid?
    self.xlsx_valid
  end

  def self.import_types
    TYPES
  end
end
