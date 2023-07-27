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

# Things appear to work fine with selenium headless_chrome
RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :cuprite
  end

  config.before(:each, type: :system, js: true) do
    driven_by :cuprite
  end

  config.include CapybaraSelect2
  config.include CapybaraSelect2::Helpers # if need specific helpers
end
