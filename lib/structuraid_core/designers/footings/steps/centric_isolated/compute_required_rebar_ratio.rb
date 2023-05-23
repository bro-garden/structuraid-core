require 'interactor'

module StructuraidCore
  module Designers
    module Footings
      module Steps
        module CentricIsolated
          # Runs the structural bending analysis and design for a centric isolated footing, generating the required reinforcement ratio and checking that the provided one is enough
          class ComputeRequiredRebarRatio
            include Interactor

            # @param footing [StructuraidCore::Elements::Footing] The footing to be designed
            # @param load_scenario [StructuraidCore::Loads::Scenarios::Footings::CentricIsolated] The load scenario to be considered
            # @param analysis_direction [Symbol] The direction for which the analysis has to be run. Should be either :length_1 or :length2
            # @param design_code [StructuraidCore::DesignCodes] The design code to be used
            # @param steel [StructuraidCore::Materials::Steel] The rebar's material
            def call
              add_analysis_results_to_context
              context.analysis_results[:bending_momentum] = compute_flexural_moment
              context.analysis_results[:required_reinforcement_ratio] = compute_required_flexural_reinforcement_ratio
            rescue Errors::DesignCodes::RequirementNotFulfilledError => e
              context.fail!(message: e.message)
            end

            private

            def add_analysis_results_to_context
              context.analysis_results = {
                bending_momentum: nil,
                required_reinforcement_ratio: nil
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
                width: footing.width(section_direction: analysis_direction),
                effective_height: footing.effective_height(section_direction: analysis_direction, above_middle: false),
                flexural_moment: flexural_moment.abs,
                capacity_reduction_factor: design_code::Rc::ReductionFactor.call(
                  strength_controlling_behaviour: :tension_controlled
                )
              )
            end

            def flexural_moment
              @flexural_moment ||= context.analysis_results[:bending_momentum]
            end

            def steel
              @steel ||= context.steel
            end

            def footing
              @footing ||= context.footing
            end

            def load_scenario
              @load_scenario ||= context.load_scenario
            end

            def analysis_direction
              @analysis_direction ||= context.analysis_direction
            end

            def design_code
              @design_code ||= context.design_code
            end
          end
        end
      end
    end
  end
end
