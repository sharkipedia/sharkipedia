RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  # Rails Preloaders and RSpec
  config.before(:suite) { FactoryBot.reload }
end
