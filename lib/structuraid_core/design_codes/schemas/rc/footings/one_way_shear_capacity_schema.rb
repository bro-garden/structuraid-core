module StructuraidCore
  module DesignCodes
    module Schemas
      module Rc
        module Footings
          class OneWayShearCapacitySchema
            include DesignCodes::Utils::SchemaDefinition

            required_params %i[
              design_compression_strength
              width
              effective_height
              light_concrete_modification_factor
            ]

            optional_params []
          end
        end
      end
    end
  end
end
