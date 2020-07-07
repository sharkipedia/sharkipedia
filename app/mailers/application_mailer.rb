class ApplicationMailer < ActionMailer::Base
  default from: ENV["SMTP_EMAIL_ADDRESS"] || Rails.application.credentials.dig(:email, :email_address)
  layout "mailer"
end
