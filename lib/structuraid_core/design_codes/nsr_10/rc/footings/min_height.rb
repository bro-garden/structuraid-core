module StructuraidCore
  module DesignCodes
    module NSR10
      module RC
        module Footings
          class MinHeight
            include DesignCodes::Utils::CodeRequirement
            use_schema DesignCodes::Schemas::RC::Footings::MinHeightSchema

            MIN_HEIGHT_MAPPINGS = {
              over_soil: 150,
              over_piles: 300
            }.freeze

            CODE_REFERENCE = 'NSR-10 C.15.7'.freeze

            def call
              support_type = params.support_type || :over_soil
              unless MIN_HEIGHT_MAPPINGS.keys.include?(support_type)
                raise UnrecognizedValueError.new(:support_type, support_type)
              end

              min_height = MIN_HEIGHT_MAPPINGS[support_type]

              return true if bottom_rebar_effective_height >= min_height

              raise RequirementNotFulfilledError.new(
                :min_height,
                "Height #{bottom_rebar_effective_height} is below #{min_height} mininmum",
                CODE_REFERENCE
              )
            end
          end
        end
      end
    end
  end
end
