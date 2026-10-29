require "capybara/rspec"
require "capybara/cuprite"

Capybara.server = :puma, {Silent: true}

# In the Docker image the Chromium binary lives at /usr/bin/chromium, not the
# default /usr/bin/google-chrome that Selenium Manager looks for.
Capybara.register_driver :headless_chromium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.binary = ENV["CHROME_BIN"] if ENV["CHROME_BIN"]
  options.binary = "/usr/bin/chromium" if File.exist?("/usr/bin/chromium")
  options.add_argument("--headless=new")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--disable-gpu")
  options.add_argument("--window-size=1400,1400")
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

# Capybara.javascript_driver = :cuprite
# Capybara.register_driver(:cuprite) do |app|
#   Capybara::Cuprite::Driver.new(app,
#     window_size: [1200, 800],
#     process_timeout: 6,
#     inspector: ENV["INSPECTOR"]
#   )
# end

# I'd like to default to cuprite and use headless chrome. However, I'm seeing
# errors with regards to the uploaded files when running in headless mode:
#
# After the excel sheet is uploaded, the sidkiq job retrieves the file and runs
# various validations. When running the tests with cuprite I get the following
# error from roo when it tries to open the excel sheet:
#
# ```
# File /var/.../ActiveStorage-1-20200523-41006-b3ba89.xlsx has zero size.
# Did you mean to pass the create flag?
# ```
#
# RSpec.configure do |config|
#   config.before(:each, type: :system) do
#     driven_by :cuprite
#   end
#
#   config.before(:each, type: :system, js: true) do
#     driven_by :cuprite
#   end
# end

# Things appear to work fine with selenium headless_chrome
RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :headless_chromium
  end

  config.before(:each, type: :system, js: true) do
    driven_by :headless_chromium
  end

  config.include CapybaraSelect2
  config.include CapybaraSelect2::Helpers # if need specific helpers
end
