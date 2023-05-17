module StructuraidCore
  module DesignCodes
    module Schemas
      module Rc
        class ElasticModulusSchema
          include DesignCodes::Utils::SchemaDefinition

          required_params %i[design_compression_strength]
          optional_params []
        end
      end
    end
  end
end
