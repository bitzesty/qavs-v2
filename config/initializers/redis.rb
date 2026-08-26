# Configure Redis connection
if ENV["REDIS_URL"].present?
  REDIS = Redis.new(url: ENV["REDIS_URL"])
else
  REDIS = Redis.new(url: "redis://localhost:6379/1")
end

# Configure cache store with Redis if available
if defined?(Redis) && ENV["REDIS_URL"].present?
  Rails.application.config.cache_store = :redis_cache_store, {
    url: ENV["REDIS_URL"],
    namespace: "cache"
  }
end
