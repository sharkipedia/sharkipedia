Sidekiq.configure_server do |config|
  config.redis = {namespace: "sharkipedia"}
end

Sidekiq.configure_client do |config|
  config.redis = {namespace: "sharkipedia"}
end

Sidekiq::Extensions.enable_delay!
