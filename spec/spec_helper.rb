require 'simplecov'

SimpleCov.formatter SimpleCov::Formatter::HTMLFormatter
SimpleCov.minimum_coverage 90
SimpleCov.start

RSpec.configure do |config|
  # Use the specified formatter
  config.formatter = :documentation
end
