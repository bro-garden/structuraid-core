module StructuraidCore
  module DesignCodes
    module Nsr10
      module Rc
        class ElasticModulus
          include DesignCodes::Utils::CodeRequirement
          use_schema DesignCodes::Schemas::Rc::ElasticModulusSchema

          # NSR-10 C.8.5.1
          def call
            4700 * Math.sqrt(params.design_compression_strength)
          end
        end
      end
    end
  end
end
