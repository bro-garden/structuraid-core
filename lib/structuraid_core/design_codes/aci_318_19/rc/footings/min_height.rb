module StructuraidCore
  module DesignCodes
    module ACI31819
      module RC
        module Footings
          class MinHeight
            include DesignCodes::Utils::CodeRequirement
            use_schema DesignCodes::Schemas::RC::Footings::MinHeightSchema

            MIN_HEIGHT = 150
            CODE_REFERENCE = 'ACI 318-19 13.3.1.2'.freeze

            def call
              return true if bottom_rebar_effective_height >= MIN_HEIGHT

              raise RequirementNotFulfilledError.new(
                :min_height,
                "Effective Height #{bottom_rebar_effective_height} is below #{MIN_HEIGHT} mininmum",
                CODE_REFERENCE
              )
            end
          end
        end
      end
    end
  end
end
