source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 7.1"
# Use postgres as the database for Active Record
gem "pg", "~> 1.5"
# Use Puma as the app server
gem "puma", "~> 6.4"
# Use SCSS for stylesheets
gem "sass-rails", "~> 6.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby
gem "webpacker", "~> 5.4"

gem "react-rails"

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.11"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 5.2"
gem "connection_pool", "~> 2.4"
gem "actionpack-action_caching", "~> 1.2"

# Use devise for authentication
gem "devise", "~> 4.9"
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem "administrate", "~> 0.19.0"
gem "administrate-field-enum"
gem "pundit", "~> 2.3"

gem "roo", "~> 2.10.1"
gem "rubyXL"
gem "aws-sdk-s3", "~> 1.147", require: false

gem "filterrific", "~> 5.2"
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

gem "aasm", "~> 5.5"
gem "after_commit_everywhere", "~> 1.4"

gem "good_job", "~> 3.27"

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem "activerecord-postgis-adapter", "~> 9.0.1"
gem "rgeo", "~> 3.0.1"
gem "rgeo-geojson", "~> 2.1.1"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

gem "jsonapi.rb", "~> 2.0.1"
gem "ransack", "~> 4.1"

gem "net-smtp", require: false
gem "net-pop", require: false
gem "net-imap", require: false

gem "vanilla_nested"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails", "~> 6.1.2"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 4.0.1"
  gem "listen", ">= 3.2", "< 3.10"
  gem "rails-erd"
  gem "annotate"
  gem "standard", require: false
end

group :test do
  gem "capybara", "~> 3.40"
  gem "webdrivers", "~> 5.3"
  gem "cuprite", "~> 0.15"

  gem "capybara-select-2", "~> 0.5.1"

  gem "factory_bot_rails", "~> 6.4"
  gem "shoulda-matchers", "~> 6.2"

  gem "jsonapi-rspec"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "bugsnag", "~> 6.26"

gem "paper_trail", "~> 15.1"

gem "coffee-rails", "~> 5.0"

gem "select2-rails", "~> 4.0", github: "argerim/select2-rails"
gem "underscore-rails", "~> 1.8"

gem "pg_search", "~> 2.3"

gem "pagy", "~> 8.2"

gem "invisible_captcha", "~> 2.3"

gem "friendly_id", "~> 5.5.1"

gem "newrelic_rpm"
