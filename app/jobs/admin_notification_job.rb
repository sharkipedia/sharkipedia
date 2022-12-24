class AdminNotificationJob < ApplicationJob
  queue_as :default

  def perform
    return unless Rails.env.production?
    return unless Import.pending_review.any?

    admins = User.admins
    emails = admins.map(&:email)
    ImportMailer.with(emails: emails).weekly_import_summary_email.deliver_later
  end
end
