require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'csv'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BackendApiSample
  class Application < Rails::Application
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins *ENV['CORS_ORIGINS'].split(',')
        resource '*', headers: :any, methods: :any, credentials: true
      end
    end

    config.autoload_paths << Rails.root.join('app/repositories')

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Use local timezone!
    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_record.default_timezone = :local

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    puts("cache_store URL = #{ENV['REDIS_CACHE_URL']}")
    config.cache_store = :redis_store, ENV['REDIS_CACHE_URL'], { expires_in: 90.minutes, raise_errors: false }

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end

if Rails.env.development?
  RSpec.configure do |config|
    config.swagger_dry_run = false
  end
end
