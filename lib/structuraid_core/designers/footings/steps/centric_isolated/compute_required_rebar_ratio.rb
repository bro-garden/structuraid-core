require 'interactor'

module StructuraidCore
  module Designers
    module Footings
      module Steps
        module CentricIsolated
          # Runs the structural bending analysis and design for a centric isolated footing, generating the required reinforcement ratio and adding it to the context
          class ComputeRequiredRebarRatio
            include Interactor
            include Interactor::ContextReader

            context_params :load_scenario, :design_code, :steel, :analysis_direction, :footing

            # @param load_scenario [StructuraidCore::Loads::Scenarios::Footings::CentricIsolated] The load scenario to be considered
            # @param design_code [StructuraidCore::DesignCodes] The design code to be used
            # @param steel [StructuraidCore::Materials::Steel] The rebar's material
            # @param analysis_direction [Symbol] The direction for which the analysis has to be run. Should be either :length_1 or :length2
            def call
              add_analysis_results_to_context
              context.analysis_results[:bending_momentum] = compute_flexural_moment

              flexural_reinforcement_ratio = compute_required_flexural_reinforcement_ratio
              add_results_to_context(flexural_reinforcement_ratio)
            rescue Errors::DesignCodes::RequirementNotFulfilledError => e
              context.fail!(message: e.message)
            end

            private

            def add_analysis_results_to_context
              context.analysis_results = {
                bending_momentum: nil,
                computed_ratio: nil,
                is_minimum_ratio: nil
              }
            end

            def compute_flexural_moment
              analysis = Engineering::Analysis::Footing::CentricIsolated.new(
                footing:,
                load_from_column: load_scenario.total_ultimate_load,
                section_direction: analysis_direction
              )

              analysis.bending_solicitation
            end

            def compute_required_flexural_reinforcement_ratio
              design_code::Rc::Footings::BendingReinforcementRatio.call(
                design_compression_strength: footing.material.design_compression_strength,
                design_steel_yield_strength: steel.yield_stress,
                width: footing.width(analysis_direction),
                effective_height: footing.effective_height(section_direction: analysis_direction, above_middle: false),
                flexural_moment: flexural_moment.abs,
                capacity_reduction_factor: design_code::Rc::ReductionFactor.call(
                  strength_controlling_behaviour: :tension_controlled
                )
              )
            end

            def add_results_to_context(flexural_reinforcement_ratio)
              context.analysis_results[:computed_ratio] = flexural_reinforcement_ratio.computed_ratio
              context.analysis_results[:is_minimum_ratio] = flexural_reinforcement_ratio.is_minimum_ratio
            end

            def flexural_moment
              @flexural_moment ||= context.analysis_results[:bending_momentum]
            end
          end
        end
      end
    end
  end
end
