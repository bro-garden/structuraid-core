module StructuraidCore
  module DesignCodes
    module Schemas
      module Rc
        module Footings
          class PunchingCriticalSectionPerimeterSchema
            include DesignCodes::Utils::SchemaDefinition

            required_params %i[
              column_section_length_1
              column_section_length_2
              column_absolute_location
              column_label
              footing
            ]

            optional_params []
          end
        end
      end
    end
  end
end
