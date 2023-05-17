module StructuraidCore
  module Errors
    module DesignCodes
      class MissingParamError < StandardError
        def initialize(param)
          super("#{param} param is required")
        end
      end
    end
  end
end
