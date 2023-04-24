module StructuraidCore
  module DesignCodes
    module Schemas
      module RC
        class MinimumSteelCoverSchema
          include DesignCodes::Utils::SchemaDefinition

          required_params %i[concrete_casting_or_exposision_case]
          optional_params %i[
            maximum_rebar_diameter
            structural_element
          ]
        end
      end
    end
  end
end