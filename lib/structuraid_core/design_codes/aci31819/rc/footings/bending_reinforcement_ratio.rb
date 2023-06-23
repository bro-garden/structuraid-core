module StructuraidCore
  module DesignCodes
    module Aci31819
      module Rc
        module Footings
          class BendingReinforcementRatio
            MINIMUM_RATIO = 0.0025
            CODE_REFERENCE = 'ACI 318-19'.freeze

            include DesignCodes::Utils::CodeRequirement
            use_schema DesignCodes::Schemas::Rc::Footings::BendingReinforcementRatioSchema

            Result = Struct.new(:computed_ratio, :is_minimum_ratio)

            def call
              computed_ratio = compute_ratio
              build_result(computed_ratio)
            end

            private

            def build_result(computed_ratio)
              Result.new(computed_ratio, computed_ratio == minimum_ratio)
            end

            def compute_ratio
              [
                solve_cuadratic_equation_for_steel_reinforcement_ratio,
                minimum_ratio
              ].max
            end

            def minimum_ratio
              MINIMUM_RATIO
            end

            ## the target is to solve [(1 - sqrt(1 - 4ac))/2a, (1 + sqrt(1 - 4ac))/2a]

            def solve_cuadratic_equation_for_steel_reinforcement_ratio
              [
                equation_solver_option_1.negative? ? Float::INFINITY : equation_solver_option_1,
                equation_solver_option_2
              ].min
            end

            def equation_solver_option_1
              (1 - equation_component_root) / (2 * equation_component_a)
            end

            def equation_solver_option_2
              (1 + equation_component_root) / (2 * equation_component_a)
            end

            def equation_component_a
              0.59 * design_steel_yield_strength / design_compression_strength
            end

            def equation_component_c
              section_area = width * effective_height # mm**2
              reduced_steel_strength = capacity_reduction_factor * design_steel_yield_strength # N/(mm**2)
              flexural_moment / (reduced_steel_strength * section_area * effective_height) # N/(mm**2)
            end

            def equation_component_root
              unless 4 * equation_component_a * equation_component_c < 1
                raise Errors::DesignCodes::RequirementNotFulfilledError.new(
                  :flexural_moment,
                  "Moment #{flexural_moment} is too hight for this element",
                  CODE_REFERENCE
                )
              end

              Math.sqrt(1 - 4 * equation_component_a * equation_component_c)
            end
          end
        end
      end
    end
  end
end
