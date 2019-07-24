class ApplicationMailer < ActionMailer::Base
  default from: ENV["SES_SMTP_EMAIL_ADDRESS"] || Rails.application.credentials.dig(:ses, :email_address)
  layout 'mailer'
end
