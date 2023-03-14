module StructuraidCore
  module DesignCodes
    class UnknownDesignCodeError < StandardError
      def initialize(code_name)
        message = "Design code #{code_name} is unknown. Must select one of #{DesignCodes::Resolver::CODES_NAMESPACES}"

        super(message)
      end
    end
  end
end
