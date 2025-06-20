redis_config = { url: ENV["REDIS_URL"] || "redis://localhost:6379/1" }

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
