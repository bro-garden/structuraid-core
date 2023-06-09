module StructuraidCore
  module Errors
    module Designers
      # This error is raised when a code requirement is not fulfilled given the params passed
      class DesignStepError < StandardError
        attr_reader :requirement, :message

        def initialize(requirement, message)
          @requirement = requirement
          @message = message

          super(message)
        end
      end
    end
  end
end
