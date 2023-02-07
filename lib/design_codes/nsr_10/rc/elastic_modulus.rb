require 'byebug'
require 'design_codes/utils/code_requirement'
require 'design_codes/schemas/rc/elastic_modulus_schema'

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
