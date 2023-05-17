# See https://pradaing.notion.site/Design-Codes-System-238dd1a6357a4b958f82e2cd7a51dd47 for usage

module StructuraidCore
  module DesignCodes
    class Resolver < Base
      CODES_NAMESPACES = {
        'nsr_10' => DesignCodes::Nsr10,
        'aci_318_19' => DesignCodes::Aci31819
      }.freeze

      class << self
        def use(code_name)
          code_abstraction = CODES_NAMESPACES[code_name]
          raise Errors::DesignCodes::UnknownDesignCodeError, code_name if code_abstraction.nil?

          code_abstraction
        end
      end
    end
  end
end
