Rails.application.configure do
  config.good_job.cron = { summary_weekly_import_email: { cron: '0 15 * * 1', class: 'AdminNotificationJob'  } }
end