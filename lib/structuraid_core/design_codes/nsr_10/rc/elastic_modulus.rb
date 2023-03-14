module StructuraidCore
  module DesignCodes
    module NSR10
      module RC
        class ElasticModulus
          include DesignCodes::Utils::CodeRequirement
          use_schema DesignCodes::Schemas::RC::ElasticModulusSchema

          # NSR-10 C.8.5.1
          def call
            4700 * Math.sqrt(params.design_compression_strength)
          end
        end
      end
    end
  end
end
