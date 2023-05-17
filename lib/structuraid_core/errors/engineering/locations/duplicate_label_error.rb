module StructuraidCore
  module Errors
    module Engineering
      module Locations
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
