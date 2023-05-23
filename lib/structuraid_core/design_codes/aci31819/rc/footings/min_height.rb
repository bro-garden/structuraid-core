module StructuraidCore
  module DesignCodes
    module Aci31819
      module Rc
        module Footings
          class MinHeight
            include DesignCodes::Utils::CodeRequirement
            use_schema DesignCodes::Schemas::Rc::Footings::MinHeightSchema

            MIN_HEIGHT = 150
            CODE_REFERENCE = 'ACI 318-19 13.3.1.2'.freeze

            def call
              return true if bottom_rebar_effective_height >= MIN_HEIGHT

              raise Errors::DesignCodes::RequirementNotFulfilledError.new(
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
