# spec/rails_helper.rb
RSpec.configure do |config|
  # Use database_cleaner to ensure the database is cleaned after each test
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
