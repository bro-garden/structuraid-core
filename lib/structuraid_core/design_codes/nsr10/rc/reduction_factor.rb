module StructuraidCore
  module DesignCodes
    module Nsr10
      module Rc
        class ReductionFactor
          include DesignCodes::Utils::CodeRequirement
          use_schema DesignCodes::Schemas::Rc::ReductionFactorSchema

          MAX_STRAIN_BEFORE_TRANSITION = 0.002
          MIN_STRAIN_AFTER_TRANSITION = 0.005

          CODE_REFERENCE = 'NSR-10 C.9.3.2'.freeze

          def call
            return tension_controlled_factor if strength_controlling_behaviour == :tension_controlled
            return compression_controlled_factor if strength_controlling_behaviour == :compression_controlled
            return crushing_controlled_factor if strength_controlling_behaviour == :crushing_controlled
            if %i[
              shear_nonseismic_controlled
              torsion_controlled
              corbel_bracket_controlled
              strud_and_tie_controlled
            ].include?(strength_controlling_behaviour)
              return shear_nonseismic_controlled_factor
            end

            transition_controlled_factor
          end

          private

          def shear_nonseismic_controlled_factor
            0.75
          end

          def crushing_controlled_factor
            0.65
          end

          def tension_controlled_factor
            0.90
          end

          def compression_controlled_factor
            return 0.75 if is_coil_rebar

            0.65
          end

          def transition_controlled_factor
            raise Errors::DesignCodes::MissingParamError, :strain unless strain

            transition_controlled_by_strain
          end

          def transition_controlled_by_strain
            return compression_controlled_factor if strain < MAX_STRAIN_BEFORE_TRANSITION
            return tension_controlled_factor if strain > MIN_STRAIN_AFTER_TRANSITION

            transition_rate = is_coil_rebar ? 50 : 250 / 3
            compression_controlled_factor + (strain - MAX_STRAIN_BEFORE_TRANSITION) * transition_rate
          end
        end
      end
    end
  end
end
