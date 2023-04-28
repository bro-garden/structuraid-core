module StructuraidCore
  module DesignCodes
    module NSR10
      module RC
        class MinimumSteelCover
          include DesignCodes::Utils::CodeRequirement
          use_schema DesignCodes::Schemas::RC::MinimumSteelCoverSchema

          CODE_REFERENCE = 'NSR-10 C.7.7.1'.freeze

          def call
            compute_cover
          end

          private

          def compute_cover
            return 75 if concrete_casting_against_soil # c.7.7.1.a
            return expossed_to_environment_or_soil if !concrete_casting_against_soil && environment_exposure # c.7.7.1.b
            return 50 unless structural_element

            non_expossed_to_environment_or_soil
          end

          def expossed_to_environment_or_soil
            return 40 if maximum_rebar_diameter&.<= 16

            50
          end

          # c.7.7.1.c
          def non_expossed_to_environment_or_soil
            if %i[slab wall joist].include?(structural_element)
              slab_wall_joist_minimum_cover
            elsif %i[beam column].include?(structural_element)
              40
            elsif %i[shell thin_shell].include?(structural_element)
              shell_minimum_cover
            end
          end

          def slab_wall_joist_minimum_cover
            return 20 if maximum_rebar_diameter&.<= 36

            40
          end

          def shell_minimum_cover
            return 13 if maximum_rebar_diameter&.<= 16

            20
          end
        end
      end
    end
  end
end
