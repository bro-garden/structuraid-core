module StructuraidCore
  module Errors
    module DesignCodes
      class UnknownDesignCodeError < StandardError
        def initialize(code_name)
          namespaces = StructuraidCore::DesignCodes::Resolver::CODES_NAMESPACES
          message = "Design code #{code_name} is unknown. Must select one of #{namespaces}"

          super(message)
        end
      end
    end
  end
end
