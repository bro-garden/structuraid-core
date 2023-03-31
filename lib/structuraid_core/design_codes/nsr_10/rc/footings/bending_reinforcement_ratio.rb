module StructuraidCore
  module DesignCodes
    module NSR10
      module RC
        module Footings
          class BendingReinforcementRatio
            MINIMUM_RATIO = 0.0025

            include DesignCodes::Utils::CodeRequirement
            use_schema DesignCodes::Schemas::RC::Footings::BendingReinforcementRatioSchema

            # NSR-10 C.10
            def call
              [
                solve_cuadratic_equation_for_steel_reinforcement_ratio,
                MINIMUM_RATIO
              ].max
            end

            private

            ## the target is to solve [(-1 - sqrt(1 - 4ac))/2a, (-1 + sqrt(1 - 4ac))/2a]

            def solve_cuadratic_equation_for_steel_reinforcement_ratio
              [
                equation_solver_option_1.negative? ? 1.0 / 0.0 : equation_solver_option_1,
                equation_solver_option_2
              ].min
            end

            def equation_solver_option_1
              (-1 - equation_component_root) / (2 * equation_component_a)
            end

            def equation_solver_option_2
              (-1 + equation_component_root) / (2 * equation_component_a)
            end

            def equation_component_a
              0.59 * design_steel_yield_strength / design_compression_strength
            end

            def equation_component_c
              flexural_moment / (
                capacity_reduction_factor * design_steel_yield_strength * width * (effective_height**2)
              )
            end

            def equation_component_root
              Math.sqrt(1 - 4 * equation_component_a * equation_component_c)
            end
          end
        end
      end
    end
  end
end
