module StructuraidCore
  module DesignCodes
    module Schemas
      module RC
        class ReductionFactorSchema
          include DesignCodes::Utils::SchemaDefinition

          required_params %i[strength_controlling_behaviour]
          optional_params %i[
            strain
            is_coil_rebar
          ]
        end
      end
    end
  end
end
