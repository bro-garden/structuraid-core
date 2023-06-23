module StructuraidCore
  module DesignCodes
    module Schemas
      module Rc
        module Footings
          # Schema for maximum rebar spacing
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

            enum :support_type, %i[
              over_soil
              over_piles
            ]
          end
        end
      end
    end
  end
end
