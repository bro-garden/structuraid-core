module StructuraidCore
  module Errors
    module DesignCodes
      # This error is raised when a param value is not recognized in an enum param
      class UnrecognizedValueError < StandardError
        def initialize(name, value)
          super("#{value} for #{name} param couldnt be recognized")
        end
      end
    end
  end
end
