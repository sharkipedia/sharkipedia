require "jsonapi/rspec"

RSpec.configure do |config|
  config.include JSONAPI::RSpec

  # Support for documents with mixed string/symbol keys. Disabled by default.
  config.jsonapi_indifferent_hash = true
end
