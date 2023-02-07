require 'design_codes/utils/schema_definition'

module DesignCodes
  module Schemas
    module RC
      class ElasticModuleSchema
        include DesignCodes::Utils::SchemaDefinition

        required_params %i[design_compression_strength]
      end
    end
  end
end
