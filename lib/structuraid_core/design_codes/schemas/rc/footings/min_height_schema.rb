module StructuraidCore
  module DesignCodes
    module Schemas
      module RC
        module Footings
          class MinHeightSchema
            include DesignCodes::Utils::SchemaDefinition

            required_params %i[bottom_rebar_effective_height]
            optional_params %i[support_type]
          end
        end
      end
    end
  end
end
