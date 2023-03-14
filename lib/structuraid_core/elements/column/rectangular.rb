module StructuraidCore
  module Elements
    module Column
      class Rectangular < Base
        attr_reader :length_x, :length_y, :height, :material

        def initialize(length_x:, length_y:, height:, material:)
          @length_x = length_x.to_f
          @length_y = length_y.to_f
          @height = height.to_f
          @material = material
        end
      end
    end
  end
end
