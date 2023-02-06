require 'byebug'
require 'design_codes/utils/code_requirement'
require 'design_codes/schemas/rc/elastic_module_schema'

module DesignCodes
  module NSR10
    module RC
      class ElasticModule
        include DesignCodes::Utils::CodeRequirement
        use_schema DesignCodes::Schemas::RC::ElasticModuleSchema

        # NSR-10 C.8.5.1
        def call
          byebug
        end
      end
    end
  end
end
