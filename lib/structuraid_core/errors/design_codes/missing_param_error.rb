module StructuraidCore
  module Errors
    module DesignCodes
      # This error is raised when a required param is not passed
      class MissingParamError < StandardError
        def initialize(param)
          super("#{param} param is required")
        end
      end
    end
  end
end
