require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # No NGINX in front: Puma serves /public (packs, assets) with long cache headers.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {"cache-control" => "public, max-age=#{1.year.to_i}"}

  # Compress CSS using a preprocessor.
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :amazon

  # TLS ends at kamal-proxy; requests reach the app over plain HTTP. Treat
  # them as HTTPS anyway, and keep HSTS and secure cookies. The health check
  # stays plain HTTP.
  config.assume_ssl = true
  config.force_ssl = true
  config.ssl_options = {redirect: {exclude: ->(request) { request.path == "/up" }}}
  config.silence_healthcheck_path = "/up"

  # Include generic and useful information about system operation, but avoid logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII).
  config.log_level = :info

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store
  # One small server and little traffic: an in-process cache is enough.
  config.cache_store = :memory_store, {size: 64.megabytes}

  # Use a real queuing backend for Active Job (and separate queues per environment).
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "sharkipedia_production"

  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require "syslog/logger"
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  # Log to stdout; Docker keeps (and caps) the logs.
  logger = ActiveSupport::Logger.new($stdout)
  logger.formatter = config.log_formatter
  config.logger = ActiveSupport::TaggedLogging.new(logger)

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  config.action_mailer.default_options = {from: ENV["SMTP_EMAIL_ADDRESS"] || Rails.application.credentials.dig(:email, :email_address)}
  config.action_mailer.smtp_settings = {
    address: ENV["SMTP_HOST"] || Rails.application.credentials.dig(:email, :smtp_host),
    port: ENV["SMTP_PORT"] || Rails.application.credentials.dig(:email, :smtp_port),
    user_name: ENV["SMTP_USERNAME"] || Rails.application.credentials.dig(:email, :smtp_username),
    password: ENV["SMTP_PASSWORD"] || Rails.application.credentials.dig(:email, :smtp_password),
    authentication: :login,
    enable_starttls_auto: true
  }

  default_url = {
    protocol: "https",
    host: ENV.fetch("DEFAULT_URL_HOST")
  }
  config.action_mailer.default_url_options = default_url
  config.action_controller.default_url_options = default_url
  Rails.application.routes.default_url_options = default_url

  config.assets.quiet = true
  # Inserts middleware to perform automatic connection switching.
  # The `database_selector` hash is used to pass options to the DatabaseSelector
  # middleware. The `delay` is used to determine how long to wait after a write
  # to send a subsequent read to the primary.
  #
  # The `database_resolver` class is used by the middleware to determine which
  # database is appropriate to use based on the time delay.
  #
  # The `database_resolver_context` class is used by the middleware to set
  # timestamps for the last write to the primary. The resolver uses the context
  # class timestamps to determine how long to wait before reading from the
  # replica.
  #
  # By default Rails will store a last write timestamp in the session. The
  # DatabaseSelector middleware is designed as such you can define your own
  # strategy for connection switching and pass that into the middleware through
  # these configuration options.
  # config.active_record.database_selector = { delay: 2.seconds }
  # config.active_record.database_resolver = ActiveRecord::Middleware::DatabaseSelector::Resolver
  # config.active_record.database_resolver_context = ActiveRecord::Middleware::DatabaseSelector::Resolver::Session

  # Solid Errors stores exceptions in the primary database; browse them at
  # /admin/errors (admins only). Email only when an error is new or reopens.
  config.solid_errors.send_emails = ENV["SOLIDERRORS_EMAIL_TO"].present?
  config.solid_errors.email_from = ENV["SMTP_EMAIL_ADDRESS"] || Rails.application.credentials.dig(:email, :email_address)
  config.solid_errors.email_every_occurrence = false
  config.solid_errors.email_subject_prefix = "[Sharkipedia]"
  config.solid_errors.destroy_after = 90.days

  # Pull request previews (config/deploy.preview.yml) run this environment
  # against a copy of the production database. They must not reach real
  # people or real files: no mail, no cron, the development S3 bucket, and
  # no search engine indexing.
  if ENV["PREVIEW"].present?
    config.action_mailer.delivery_method = :test
    config.solid_errors.send_emails = false
    config.action_dispatch.default_headers["X-Robots-Tag"] = "noindex, nofollow"
  end
end
