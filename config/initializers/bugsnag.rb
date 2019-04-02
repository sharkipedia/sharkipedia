Bugsnag.configure do |config|
  config.api_key = Rails.application.credentials.dig(:bugsnag, :api_key)
  config.notify_release_stages = ['production']
end
