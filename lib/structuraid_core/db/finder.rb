require 'yaml'

module StructuraidCore
  module Db
    # This module is responsible for finding data in different yaml files stored under this directory
    module Finder
      STANDARD_REBAR = YAML.load_file('lib/structuraid_core/db/rebars.yml')

      def self.find_standard_rebar(number:)
        STANDARD_REBAR.find { |rebar_data| rebar_data['number'] == number }
      end
    end
  end
end
