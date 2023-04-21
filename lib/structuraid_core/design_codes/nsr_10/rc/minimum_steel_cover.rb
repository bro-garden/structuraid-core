module StructuraidCore
  module DesignCodes
    module NSR10
      module RC
        class MinimumSteelCoverSchema
          include DesignCodes::Utils::CodeRequirement
          use_schema DesignCodes::Schemas::RC::MinimumSteelCoverSchema

          CONCRETE_CASTING_OR_EXPOSISION_CASES = %w[
            c.7.7.1.a
            c.7.7.1.b
            c.7.7.1.c
          ].freeze

          STRUCTURAL_ELEMENTS = %i[
            slab
            wall
            joist
            beam
            column
            shell
          ].freeze

          CODE_REFERENCE = 'NSR-10 C.7.7.1'.freeze

          def call
            unless CONCRETE_CASTING_OR_EXPOSISION_CASES.include?(concrete_casting_or_exposision_case)
              raise UnrecognizedValueError.new(concrete_casting_or_exposision_case, :concrete_casting_or_exposision_case)
            end

            compute_cover
          end

          private

          def compute_cover
            return 0.075 if concrete_casting_or_exposision_case == 'c.7.7.1.a'
            return expossed_to_environment_or_soil if  concrete_casting_or_exposision_case == 'c.7.7.1.b'
            return 0.050 unless maximum_rebar_diameter && structural_element

            non_expossed_to_environment_or_soil
          end

          def expossed_to_environment_or_soil
            return 0.050 if maximum_rebar_diameter <= 0.016

            0.040
          end

          def non_expossed_to_environment_or_soil
            unless STRUCTURAL_ELEMENTS.include?(structural_element)
              raise UnrecognizedValueError.new(structural_element, :structural_element)
            end

            if %i[slab wall joist].include?(structural_element)
              return 0.020 if maximum_rebar_diameter <= 0.036

              0.040
            elsif structural_element == :shell
              return 0.013 if maximum_rebar_diameter <= 0.016

              0.020
            end

            0.040
          end
        end
      end
    end
  end
end
