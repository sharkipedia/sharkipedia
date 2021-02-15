require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sharkipedia
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.active_job.queue_adapter = :sidekiq

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
