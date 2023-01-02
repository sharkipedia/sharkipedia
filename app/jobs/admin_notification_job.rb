class AdminNotificationJob < ApplicationJob
  queue_as :default

  def perform
    return unless should_run?

    emails = User.admin_emails
    ImportMailer.with(emails: emails).weekly_import_summary_email.deliver_later
  end

  private

  def should_run?
    Rails.env.production? && Import.pending_review.any?
  end
end
