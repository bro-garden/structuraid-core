require 'interactor'

module StructuraidCore
  module Designers
    module Footings
      module Steps
        # Checks if footing's height is greater at least the minimum required height
        class CheckMinHeight
          include Interactor
          include Interactor::ContextReader

          # @param footing [StructuraidCore::Elements::Footing] The footing to be designed
          # @param support_type [Symbol or String] The support type: :over_soil or :over_piles
          def call
            compute_required_flexural_reinforcement_ratio
          rescue Errors::DesignCodes::RequirementNotFulfilledError => e
            context.fail!(message: e.message)
          rescue Errors::DesignCodes::UnrecognizedValueError => e
            context.fail!(message: e.message)
          end

          private

          def compute_required_flexural_reinforcement_ratio
            design_code::Rc::Footings::MinHeight.call(
              bottom_rebar_effective_height: footing.effective_height(
                section_direction: analysis_direction,
                above_middle: false
              ),
              support_type:
            )
          end

          def analysis_direction
            @analysis_direction ||= context.analysis_direction
          end

          def design_code
            @design_code ||= context.design_code
          end

          def footing
            @footing ||= context.footing
          end

          def support_type
            @support_type ||= context.support_type
          end
        end
      end
    end
  end
end
