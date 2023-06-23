module StructuraidCore
  module DesignCodes
    module Nsr10
      module Rc
        module Footings
          # Maximum footing longitudinal rebar spacing, based on NSR-10
          class MaximumRebarSpacing
            include DesignCodes::Utils::CodeRequirement
            use_schema DesignCodes::Schemas::Rc::Footings::MaximumRebarSpacingSchema

            MIN_HEIGHT_MAPPINGS = {
              over_soil: 150,
              over_piles: 300
            }.freeze

            CODE_REFERENCE = 'NSR-10 c.10.5.4 and C.10.6.4'.freeze

            def call
              return maximum_by_minimum_rebar_ratio if for_min_rebar

              maximum_by_yield_stress
            end

            private

            def maximum_by_minimum_rebar_ratio
              [
                3 * footing_height,
                450
              ].min
            end

            def maximum_by_yield_stress
              [
                (380 * 280 / (2 * yield_stress / 3)) - 2.5 * reinforcement_cover,
                300 * 280 / (2 * yield_stress / 3)
              ].min
            end
          end
        end
      end
    end
  end
end
