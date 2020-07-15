source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Redis for caching
gem 'hiredis'
gem 'redis-rails', '~> 5.0', '>= 5.0.2'
gem 'sidekiq'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# Use stripe gem for payments
gem 'stripe', '~> 4.9.0'

# SendGrid Gem
gem 'sendgrid-ruby'

gem 'will_paginate'

# Social Network authentications
# Facebook Auth
gem 'koala', '~> 2.2'
gem 'oauth2', '~> 1.2'

# Authorization policy
gem 'pundit', '~> 2.0.1'

gem 'holidays'

# Search method
gem 'ransack', '2.1.1'

# Soft delete and version tracking
gem 'acts_as_paranoid', '0.6.0'
gem 'audited', '4.8.0'

gem 'rqrcode', '0.10.1'
gem 'wicked_pdf', '1.1.0'
gem 'countries', '~> 3.0.0'

# http
gem 'rest-client', '~> 2.0.2'

# geocoder
gem 'geocoder', '~> 1.2.6'
gem 'geokit', '~> 1.13.1'

gem 'request_store', '~> 1.4.1'
gem 'interactor', "~> 3.0"
gem 'state_machines', "~> 0.5.0"
gem 'jit_preloader', '~> 0.1.0'
gem 'shopify_app', '~> 11.2.0'
gem 'measured', '~> 2.5.1'
gem 'measured-rails', '~> 2.5.1'
gem 'array_enum', '~> 1.2.0'
gem 'liquid', '~> 4.0.3'

gem 'rswag-api'
gem 'rswag-ui'
gem 'rspec_junit_formatter', '~> 0.4.1'

gem 'newrelic_rpm'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_bot_rails', '4.11.1', require: false
  gem 'faker'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-json_expectations'
  gem 'shoulda-matchers', '3.1.3'

  # Gems to speed up network requests
  gem 'vcr'
  gem 'webmock', '~> 3.5.0'

  # Time-travel capabilities
  gem 'timecop', '~> 0.9.1'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
  gem 'rswag-specs'
end

group :test do
  gem 'rspec-sidekiq'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop'
  gem 'state_machines-graphviz', '~> 0.0.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
