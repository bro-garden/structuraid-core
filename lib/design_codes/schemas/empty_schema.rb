require 'design_codes/utils/schema_definition'

module DesignCodes
  module Schemas
    class EmptySchema
      include DesignCodes::Utils::SchemaDefinition

      required_params []
      optional_params []
    end
  end
end
