module StructuraidCore
  module DesignCodes
    module Schemas
      module Rc
        module Footings
          class BendingReinforcementRatioSchema
            include DesignCodes::Utils::SchemaDefinition

            required_params %i[
              design_compression_strength
              design_steel_yield_strength
              width
              effective_height
              flexural_moment
              capacity_reduction_factor
            ]

            optional_params []
          end
        end
      end
    end
  end
end
