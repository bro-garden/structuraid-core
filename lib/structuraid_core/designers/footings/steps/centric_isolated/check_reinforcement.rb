require 'interactor'

module StructuraidCore
  module Designers
    module Footings
      module Steps
        module CentricIsolated
          # Checks supplied reinforcement: ratio and spacing
          class CheckReinforcement
            include Interactor

            # @param footing [StructuraidCore::Elements::Footing] The footing to be designed
            # @param analysis_results [Hash] The analysis results
            # @param design_code [StructuraidCore::DesignCodes] The design code to be used
            # @param analysis_direction [Symbol] The direction for which the analysis has to be run. Should be either :length_1 or :length2
            # @param support_type [Symbol or String] The support type: :over_soil or :over_piles
            # @param steel [StructuraidCore::Materials::Steel] The rebar's material
            def call
              check_reinforcement_ratio
              check_reinforcement_spacing
            end

            private

            def check_reinforcement_ratio
              reinforcement_ratio = footing.reinforcement_ratio(direction: analysis_direction,
                                                                above_middle: false)
              return unless reinforcement_ratio < conmputed_ratio

              context.fail!(message: 'Reinforcement ratio is less than the minimum required')
            end

            def check_reinforcement_spacing
              reinforcement = footing.reinforcement(direction: analysis_direction, above_middle: false)
              spacing = reinforcement.max_spacing
              return unless spacing > design_code_max_spacing

              context.fail!(message: 'Reinforcement spacing is greater than maximum')
            end

            def design_code_max_spacing
              context.design_code::Rc::Footings::MaximumRebarSpacing.call(
                support_type: context.support_type,
                footing_height: footing.height,
                for_min_rebar: for_min_rebar?,
                yield_stress: steel.yield_stress,
                reinforcement_cover: footing.cover_bottom
              )
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

            def for_min_rebar?
              context.analysis_results[:is_minimum_ratio]
            end

            def steel
              context.steel
            end
          end
        end
      end
    end
  end
end
