source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.0.2"
# Use postgres as the database for Active Record
gem "pg", "~> 1.2"
# Use Puma as the app server
gem "puma", "~> 4.3"
# Use SCSS for stylesheets
gem "sass-rails", "~> 6.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby
gem "webpacker", "~> 5.1"

gem "react-rails"

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.10"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Use devise for authentication
gem "devise", "~> 4.7"
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem "administrate", "~> 0.13.0"
gem "pundit", "~> 2.1"

gem "roo", "~> 2.8.0"
gem "rubyXL"
gem "aws-sdk-s3", "~> 1.61", require: false

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

gem "aasm", "~> 5.0", ">= 5.0.1"

gem "sidekiq", "< 7"
gem "redis-namespace", "~> 1.7"

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails", "~> 4.0.0"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 4.0.1"
  gem "listen", ">= 3.2", "< 3.3"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "rails-erd"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers", "~> 4.3"

  gem "factory_bot_rails", "~> 5.0", ">= 5.0.1"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "bugsnag", "~> 6.12"

gem "paper_trail", "~> 10.2"

gem "coffee-rails", "~> 5.0"

gem "select2-rails", "~> 4.0", github: "pdobb/select2-rails"
gem "underscore-rails", "~> 1.8"

gem "pg_search", "~> 2.2"

gem "pagy", "~> 3.7"

gem "invisible_captcha", "~> 1.0"

gem "friendly_id", "~> 5.3.0"

gem "lograge"
