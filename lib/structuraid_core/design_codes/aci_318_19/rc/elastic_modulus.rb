module StructuraidCore
  module DesignCodes
    module ACI31819
      module RC
        class ElasticModulus
          include DesignCodes::Utils::CodeRequirement
          use_schema DesignCodes::Schemas::RC::ElasticModulusSchema

          # ACI 318-19 19.2.2.1
          def call
            4700 * Math.sqrt(params.design_compression_strength)
          end
        end
      end
    end
  end
end
