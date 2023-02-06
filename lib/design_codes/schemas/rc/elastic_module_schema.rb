require 'design_codes/utils/schema_definition'

module DesignCodes
  module Schemas
    module RC
      class ElasticModuleSchema
        include DesignCodes::Utils::SchemaDefinition

        required_params %i[ultimate_strength]
        optional_params %i[density]
      end
    end
  end
end
