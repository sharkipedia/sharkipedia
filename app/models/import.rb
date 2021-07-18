require "./lib/import_xlsx"

class Import < ApplicationRecord
  include AASM
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :approved_by, class_name: "User", optional: true

  has_many :trends
  has_many :observations

  validates :title, presence: true

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

    after_all_transitions :notify_uploader

    event :validate_upload, after: :notify_admins do
      transitions from: [:uploaded], to: :pending_review
    end

    event :request_changes do
      transitions from: [:pending_review, :uploaded, :approved],
        to: :changes_requested
    end

    event :resubmit do
      transitions from: [:changes_requested], to: :uploaded
    end

    event :approve, after_commit: :queue_import do
      transitions from: [:pending_review], to: :approved,
        guard: :xlsx_valid?
    end

    event :reject do
      transitions from: [:uploaded, :pending_review], to: :rejected
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
    unless mass_import?
      validate_upload!
      return
    end

    result = nil
    xlsx_file.open do |file|
      result = Xlsx::Validator.call(file)
    end
    self.import_type = result.type
    self.log = result.messages.join("\n")
    self.xlsx_valid = result.valid
    save!

    if xlsx_valid
      validate_upload!
    elsif import_type == "invalid"
      reject!
    else
      request_changes!
    end
  end

  def queue_import
    if mass_import?
      ImportJob.perform_later self
    else
      import!
    end
  end

  def do_import
    unless mass_import?
      import!
      return
    end

    i = nil

    xlsx_file.open do |file|
      # TODO: automatically detect the file type from the XLSX
      # i.e. if it's a trend or traits import
      i = case import_type
      when "traits"
        ImportXlsx::Traits.new file, user, self
      when "trends"
        ImportXlsx::Trends.new file, user, self
      end
    end

    # TODO: handle import failure
    if i.import
      import!
    else
      request_changes!
    end
    self.log += "\n" + i.log
    save!
  end

  def notify_uploader
    ImportMailer.with(import: self).update_import_status_email.deliver_later
  end

  def notify_admins
    ImportMailer.with(import: self).new_import_email.deliver_later
  end

  def do_publish
    # publish the imported data
  end

  def mass_import?
    xlsx_file.present?
  end

  def uploaded_by
    user.email
  end

  def xlsx_valid?
    if mass_import?
      xlsx_valid
    else
      true
    end
  end
end
