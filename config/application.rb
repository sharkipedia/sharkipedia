require_relative "boot"

require "rails"
# Every framework from rails/all except Action Cable, which the app doesn't use.
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sharkipedia
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    config.active_job.queue_adapter = :good_job

    # The region GeoJSON (/regions/*.geojson) is several hundred KB of
    # coordinates and compresses ~5x; gzip it regardless of the proxy in front.
    config.middleware.use Rack::Deflater,
      if: ->(_env, _status, headers, _body) { headers["content-type"].to_s.start_with?("application/geo+json") }

    config.generators do |g|
      g.view_specs false
      g.javascript_engine :js
    end

    config.to_prepare do
      # NOTE: https://github.com/thoughtbot/administrate/issues/334
      # Autoreloading of code does not work
      Administrate::ApplicationController.helper Sharkipedia::Application.helpers
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
