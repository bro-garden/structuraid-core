module StructuraidCore
  module DesignCodes
    module Schemas
      module Rc
        class ReductionFactorSchema
          include DesignCodes::Utils::SchemaDefinition

          required_params %i[strength_controlling_behaviour]
          optional_params %i[
            strain
            is_coil_rebar
          ]

          enum :strength_controlling_behaviour, %i[
            compression_controlled
            tension_controlled
            transition_controlled
            crushing_controlled
            shear_nonseismic_controlled
            torsion_controlled
            corbel_bracket_controlled
            strud_and_tie_controlled
          ]
        end
      end
    end
  end
end
