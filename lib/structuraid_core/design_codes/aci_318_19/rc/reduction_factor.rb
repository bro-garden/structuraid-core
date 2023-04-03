module StructuraidCore
  module DesignCodes
    module ACI31819
      module RC
        class ReductionFactor
          include DesignCodes::Utils::CodeRequirement
          use_schema DesignCodes::Schemas::RC::ReductionFactorSchema

          CONTROL_STRENGTH_CASES = %i[
            compression_controlled
            tension_controlled
            transition_controlled
            crushing_controlled
            shear_nonseismic_controller
            torsion_controlled
            corbel_bracket_controlled
            strud_and_tie_controlled
          ].freeze

          MAX_STRAIN_BEFORE_TRANSITION = 0.002 # 21.2.2.1 - 21.2.2.2
          MIN_STRAIN_AFTER_TRANSITION = 0.005 # 21.2.2.1 - 21.2.2.2

          CODE_REFERENCE = 'ACI 318-19 21.2'.freeze

          # ACI 318-19 21.2
          def call
            unless CONTROL_STRENGTH_CASES.include?(strength_controlling_behaviour)
              raise UnrecognizedValueError.new(strength_controlling_behaviour, :strength_controlling_behaviour)
            end

            # Table 21.2.1 (a) (h)
            return tension_controlled_factor if strength_controlling_behaviour == :tension_controlled
            # Table 21.2.1 (a)
            return compression_controlled_factor if strength_controlling_behaviour == :compression_controlled
            # Table 21.2.1 (d)
            return crushing_controlled_factor if strength_controlling_behaviour == :crushing_controlled
            # Table 21.2.1 (b) (c) (f) (g)
            if %i[
              shear_nonseismic_controller
              torsion_controlled
              corbel_bracket_controlled
              strud_and_tie_controlled
            ].include?(strength_controlling_behaviour)
              return shear_nonseismic_controller_factor
            end

            # Table 21.2.1 (a)
            transition_controlled_factor
          end

          private

          def shear_nonseismic_controller_factor
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
            raise MissingParamError, :strain unless strain

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