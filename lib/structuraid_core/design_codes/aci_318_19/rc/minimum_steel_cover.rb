module StructuraidCore
  module DesignCodes
    module Aci31819
      module Rc
        class MinimumSteelCover
          include DesignCodes::Utils::CodeRequirement
          use_schema DesignCodes::Schemas::Rc::MinimumSteelCoverSchema

          CODE_REFERENCE = 'ACI 318-19 21.5.1.3.1'.freeze

          def call
            compute_cover
          end

          private

          # Table 20.5.1.3.1
          def compute_cover
            return 75 if concrete_casting_against_soil
            return expossed_to_environment_or_soil if !concrete_casting_against_soil && environment_exposure
            return 50 unless structural_element

            non_expossed_to_environment_or_soil
          end

          def expossed_to_environment_or_soil
            return 40 if maximum_rebar_diameter&.<= 16

            50
          end

          def non_expossed_to_environment_or_soil
            if %i[slab wall joist].include?(structural_element)
              slab_wall_joist_minimum_cover
            elsif %i[beam column tensor_joint pedestal].include?(structural_element)
              40
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
