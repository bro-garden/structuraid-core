module StructuraidCore
  module Errors
    module Engineering
      module Locations
        # This error is raised when a location with the same label already exists for a coordinates system
        class DuplicateLabelError < StandardError
          def initialize(label)
            message = "location with label: #{label} already exists"

            super(message)
          end
        end
      end
    end
  end
end
