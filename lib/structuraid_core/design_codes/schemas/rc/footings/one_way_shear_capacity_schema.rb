module StructuraidCore
  module DesignCodes
    module Schemas
      module RC
        module Footings
          class OneWayShearCapacitySchema
            include DesignCodes::Utils::SchemaDefinition

            required_params %i[
              design_compression_strength
              width
              effective_height
              capacity_reduction_factor
              light_concrete_modification_factor
            ]

            optional_params []
          end
        end
      end
    end
  end
end
