module StructuraidCore
  module Engineering
    module Locations
      class Relative < Base
        attr_accessor :value_1, :value_2, :value_3

        def initialize(value_1:, value_2:, value_3:)
          @value_1 = value_1.to_f
          @value_2 = value_2.to_f
          @value_3 = value_3.to_f
        end
      end
    end
  end
end
