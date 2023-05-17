module StructuraidCore
  module Elements
    module Column
      class Rectangular
        attr_reader :length_1, :length_2, :height, :material, :label

        def initialize(length_1:, length_2:, height:, material:, label: nil)
          @length_1 = length_1.to_f
          @length_2 = length_2.to_f
          @height = height.to_f
          @material = material
          @label = label&.to_sym
        end
      end
    end
  end
end
