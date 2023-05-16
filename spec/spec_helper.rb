# frozen_string_literal: true

require 'simplecov'
require 'support/factory_bot'

SimpleCov.formatter SimpleCov::Formatter::HTMLFormatter
SimpleCov.minimum_coverage 90
SimpleCov.start do
  enable_coverage :branch

  add_group 'DB', 'lib/structuraid_core/db'
  add_group 'DesignCodes', 'lib/structuraid_core/design_codes'
  add_group 'Elements', 'lib/structuraid_core/elements'
  add_group 'Engineering', 'lib/structuraid_core/engineering'
  add_group 'Loads', 'lib/structuraid_core/loads'
  add_group 'Materials', 'lib/structuraid_core/materials'
  add_group 'Errors', 'lib/structuraid_core/errors'

  add_filter 'spec/'
end

require 'structuraid_core'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
