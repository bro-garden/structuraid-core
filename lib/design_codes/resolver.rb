require 'require_all'
require_all 'lib/design_codes/nsr_10'
require_all 'lib/design_codes/aci_318_19'
require_all 'lib/errors/design_codes'

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
