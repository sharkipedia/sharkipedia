Rails.application.configure do
  config.good_job.cron = {summary_weekly_import_email: {cron: "0 15 * * 1", class: "AdminNotificationJob"}}
  # Cron runs in the production worker only; previews share production's data
  # but must not send the weekly email.
  config.good_job.enable_cron = Rails.env.production? && ENV["PREVIEW"].blank?
end
