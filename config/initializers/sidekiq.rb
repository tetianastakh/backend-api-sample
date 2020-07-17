require 'sidekiq/api'

redis_config = { url: ENV['REDIS_SIDEKIQ_URL'] || 'redis://redis:6379/0' }

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end

# require 'sidekiq/web'
# Sidekiq::Web.app_url = '/'
