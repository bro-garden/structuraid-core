require 'design_codes/utils/code_requirement'
require 'design_codes/schemas/rc/elastic_module_schema'

module DesignCodes
  module ACI31819
    module RC
      class ElasticModule
        include DesignCodes::Utils::CodeRequirement
        use_schema DesignCodes::Schemas::RC::ElasticModuleSchema

        def call
        end
      end
    end
  end
end
