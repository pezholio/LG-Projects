ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

require 'webmock/rspec'
require 'database_cleaner'
require 'vcr'
require 'pry'

DatabaseCleaner.strategy = :truncation

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

VCR.configure do |c|
  ignore_env = %w{SHLVL RUNLEVEL GUARD_NOTIFY DRB COLUMNS USER LOGNAME LINES TERM_PROGRAM_VERSION}
  (ENV.keys-ignore_env).select{|x| x =~ /\A[A-Z_]*\Z/}.each do |key|
    c.filter_sensitive_data("<#{key}>") { ENV[key] }
  end
  c.cassette_library_dir = 'spec/cassettes'
  c.default_cassette_options = { :record => :once }
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  include ActionDispatch::TestProcess

  WebMock.disable_net_connect!
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
