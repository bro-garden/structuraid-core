require 'require_all'
require_all 'lib/design_codes/nsr_10'
require_all 'lib/design_codes/aci_318_19'
require_all 'lib/errors/design_codes'

# See https://pradaing.notion.site/Design-Codes-System-238dd1a6357a4b958f82e2cd7a51dd47 for usage

module DesignCodes
  class Resolver
    CODES_NAMESPACES = {
      'nsr_10' => DesignCodes::NSR10,
      'aci_318_19' => DesignCodes::ACI31819
    }.freeze

    class << self
      def use(code_name)
        code_abstraction = CODES_NAMESPACES[code_name]
        raise DesignCodes::UnknownDesignCodeError, code_name if code_abstraction.nil?

        code_abstraction
      end
    end
  end
end
