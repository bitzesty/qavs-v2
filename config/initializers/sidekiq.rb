Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDIS_URL"], id: nil }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_URL"], id: nil }
end
