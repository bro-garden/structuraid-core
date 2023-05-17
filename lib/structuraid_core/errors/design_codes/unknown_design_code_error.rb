module StructuraidCore
  module Errors
    module DesignCodes
      class UnknownDesignCodeError < StandardError
        def initialize(code_name)
          message = "Design code #{code_name} is unknown. Must select one of #{StructuraidCore::DesignCodes::Resolver::CODES_NAMESPACES}"

          super(message)
        end
      end
    end
  end
end
