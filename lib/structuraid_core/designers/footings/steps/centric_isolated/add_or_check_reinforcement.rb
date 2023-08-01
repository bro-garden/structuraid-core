require 'interactor'

module StructuraidCore
  module Designers
    module Footings
      module Steps
        module CentricIsolated
          # Resolves what to run in the design flow: add reinforcement or check reinforcement ratio
          class AddOrCheckReinforcement
            include Interactor

            # @param footing [StructuraidCore::Elements::Footing] The footing to be designed
            # @param analysis_direction [Symbol] The direction for which the analysis has to be run. Should be either :length_1 or :length2
            # @param analysis_results [Hash] The analysis results
            # @param design_code [StructuraidCore::DesignCodes] The design code to be used
            # @param steel [StructuraidCore::Materials::Steel] The rebar's material
            # @param support_type [Symbol or String] The support type: :over_soil or :over_piles
            def call
              return add_reinforcement if footing_has_reinforcement?

              check_reinforcement
            end

            private

            def footing_has_reinforcement?
              context.footing.reinforcement(
                direction: context.analysis_direction, above_middle: false
              ).nil?
            end

            def add_reinforcement
              Steps::CentricIsolated::SetReinforcementLayersCoordinatesToFooting.call!(context)
              Steps::CentricIsolated::SetInitialLongitudinalReinforcement.call!(context)
            end

            def check_reinforcement
              Steps::CentricIsolated::CheckReinforcement.call!(context)
            end
          end
        end
      end
    end
  end
end
