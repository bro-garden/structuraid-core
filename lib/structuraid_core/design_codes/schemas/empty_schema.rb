module StructuraidCore
  module DesignCodes
    module Schemas
      class EmptySchema
        include DesignCodes::Utils::SchemaDefinition

        required_params []
        optional_params []
      end
    end
  end
end
