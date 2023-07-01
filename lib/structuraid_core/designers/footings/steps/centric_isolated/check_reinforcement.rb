require 'interactor'

module StructuraidCore
  module Designers
    module Footings
      module Steps
        module CentricIsolated
          # Checks supplied reinforcement: ratio and spacing
          class CheckReinforcement
            # @param footing [StructuraidCore::Elements::Footing] The footing to be designed
            # @param analysis_results [Hash] The analysis results
            # @param design_code [StructuraidCore::DesignCodes] The design code to be used
            # @param analysis_direction [Symbol] The direction for which the analysis has to be run. Should be either :length_1 or :length2
            def call
              check_reinforcement_ratio
              check_reinforcement_spacing
            end

            private

            def check_reinforcement_ratio
              reinforcement_ratio = footing.reinforcement_ratio(direction: analysis_direction,
                                                                above_middle: false)
              return unless reinforcement_ratio < conmputed_ratio

              footing.destroy_reinforcement(direction: analysis_direction, above_middle: false)
              context.fail!(message: 'Reinforcement ratio is less than the minimum required')
            end

            def check_reinforcement_spacing
              nil
            end

            def footing
              context.footing
            end

            def analysis_direction
              context.analysis_direction
            end

            def conmputed_ratio
              context.analysis_results[:computed_ratio]
            end
          end
        end
      end
    end
  end
end
