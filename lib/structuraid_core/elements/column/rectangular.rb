module StructuraidCore
  module Elements
    module Column
      class Rectangular < Base
        attr_reader :length_1, :length_2, :height, :material

        def initialize(length_1:, length_2:, height:, material:)
          @length_1 = length_1.to_f
          @length_2 = length_2.to_f
          @height = height.to_f
          @material = material
        end
      end
    end
  end
end
