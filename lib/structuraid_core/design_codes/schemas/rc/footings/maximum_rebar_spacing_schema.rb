module StructuraidCore
  module DesignCodes
    module Schemas
      module Rc
        module Footings
          class MaximumRebarSpacingSchema
            include DesignCodes::Utils::SchemaDefinition

            required_params %i[
              support_type
              footing_height
              for_min_rebar
              yield_stress
              reinforcement_cover
            ]
            optional_params []
          end
        end
      end
    end
  end
end
