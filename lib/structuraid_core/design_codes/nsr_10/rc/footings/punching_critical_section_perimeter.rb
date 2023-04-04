module StructuraidCore
  module DesignCodes
    module Schemas
      module RC
        module Footings
          class PunchingCriticalSectionPerimeter
            CODE_REFERENCE = 'NSR-10 C.11.11'.freeze

            include DesignCodes::Utils::CodeRequirement
            use_schema DesignCodes::Schemas::RC::Footings::PunchingCriticalSectionPerimeterSchema

            # NSR-10 C.11.11

            def call
              add_column_to_local_coordinates_system
            end

            private

            def add_column_to_local_coordinates_system
              column_relative_location = Engineeringg::Locations::Relative.new(
                value_1: 0,
                value_2: 0,
                value_3: 0
              )
              column_relative_location.update_from_vector(
                column_absolute_location.to_vector - local_coordinates_system.anchor_location.to_vector
              )
              local_coordinates_system.clear_locations
              local_coordinates_system.add_location(column_relative_location)
            end

            def local_coordinates_system
              footing.local_coordinates_system
            end
          end
        end
      end
    end
  end
end
