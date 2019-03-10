Sidekiq.configure_server do |config|
  config.redis = { namespace: "sharkT" }
end

Sidekiq.configure_client do |config|
  config.redis = { namespace: "sharkT"}
end
