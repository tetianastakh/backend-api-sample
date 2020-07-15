# This file is copied to spec/ when you run 'rails generate rspec:install'

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'factory_bot_rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

FactoryBot::SyntaxRunner.class_eval do
  include ActionDispatch::TestProcess
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

VCR.configure do |vcr|
  vcr.cassette_library_dir = 'spec/fixtures/vcr'
  vcr.default_cassette_options = {
    record: :new_episodes,
    allow_playback_repeats: true
  }

  vcr.configure_rspec_metadata!

  vcr.ignore_request do |request|
    ## Ignore requests using any write-related HTTP method
    # The following methods are available:
    # :head, :options, :get, :post, :put, :patch, :delete
    ignored_paths = %w[]
    parsed_uri     = URI.parse(request.uri)
    non_idempotent = request.method.in?([:post, :put, :patch, :delete])
    is_ignored     = ignored_paths.any? { |path| parsed_uri.path.start_with?(path) }

    is_stripe && non_idempotent || is_ignored
  end

  vcr.around_http_request do |request|
    uri       = URI(request.uri)
    url_parts = [uri.scheme, uri.host, uri.path, uri.query]
    cassette  = url_parts.compact.join('/').gsub(/&|=/, '_').chomp('/')

    VCR.use_cassette(cassette, &request)
  end

  vcr.hook_into :webmock # or :fakeweb
  vcr.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.filter_run_excluding archived: true

  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Load files from support
  Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If you want to run specific tests, uncomment this
  # config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  config.define_derived_metadata(file_path: %r{/spec/lib/tasks/}) do |metadata|
    metadata[:type] = :task
  end

  config.include TaskFormat, type: :task

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.before(:suite) do
    new_time = Time.utc(2018, 2, 7, 8, 0, 0)
    Timecop.travel(new_time)

    AvailabilitySlotDefaultSeed.setup
  end

  config.before(:each, :skip_image_upload) do
    # Prevent image uploads to Cloudinary
    allow_any_instance_of(Cloudinary::V1::Client).to receive(:upload)
      .and_return(build(:cloudinary_upload_response))
  end

  config.after(:each) do
    User.reset
  end

  config.include FactoryBot::Syntax::Methods
end
