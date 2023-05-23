module StructuraidCore
  module Errors
    module Engineering
      module Analysis
        # This error is raised when a section direction is not valid for analysis
        class SectionDirectionError < StandardError
          def initialize(section_direction, valid_options)
            message = "#{section_direction} is not a valid direction, should one of #{valid_options}"

            super(message)
          end
        end
      end
    end
  end
end
