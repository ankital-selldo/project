require 'spec_helper'
require 'rails/all'
require 'factory_bot_rails'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

RSpec.configure do |config|
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.fixture_paths = ["#{::Rails.root}/spec/fixtures"] if config.respond_to?(:fixture_paths=)

  # config.use_transactional_fixtures = true
  # config.infer_spec_type_from_file_location!
  # config.filter_rails_from_backtrace!
  
  # Include Factory Bot syntax methods
  config.include FactoryBot::Syntax::Methods
end