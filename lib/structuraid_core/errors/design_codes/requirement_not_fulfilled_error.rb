module StructuraidCore
  module Errors
    module DesignCodes
      class RequirementNotFulfilledError < StandardError
        attr_reader :requirement, :message, :code_reference

        def initialize(requirement, message, code_reference)
          @requirement = requirement
          @message = message
          @code_reference = code_reference

          super(message)
        end
      end
    end
  end
end
