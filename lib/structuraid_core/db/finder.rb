require 'yaml'

module StructuraidCore
  module Db
    module Finder
      STANDARD_REBAR = YAML.load_file('lib/structuraid_core/db/rebars.yml')

      def self.find_standard_rebar(number:)
        STANDARD_REBAR.find { |rebar_data| rebar_data['number'] == number }
      end
    end
  end
end
