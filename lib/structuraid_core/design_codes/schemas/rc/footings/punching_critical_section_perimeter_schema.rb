module StructuraidCore
  module DesignCodes
    module Schemas
      module RC
        module Footings
          class PunchingCriticalSectionPerimeterSchema
            include DesignCodes::Utils::SchemaDefinition

            required_params %i[
              column_section_width
              column_section_height
              column_relative_location
              footing
            ]

            optional_params []
          end
        end
      end
    end
  end
end
