require "capybara/rspec"
require "capybara/cuprite"

Capybara.server = :puma, {Silent: true}

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
    driven_by :selenium, using: :headless_chrome
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium, using: :headless_chrome
  end

  config.include CapybaraSelect2
  config.include CapybaraSelect2::Helpers # if need specific helpers
end
