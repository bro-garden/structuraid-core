require 'matrix'

module StructuraidCore
  module Engineering
    module Locations
      class Absolute
        attr_reader :value_x, :value_y, :value_z

        def initialize(value_x:, value_y:, value_z:)
          @value_x = value_x.to_f
          @value_y = value_y.to_f
          @value_z = value_z.to_f
        end

        def to_matrix
          Matrix.column_vector(
            [
              value_x,
              value_y,
              value_z
            ]
          )
        end

        def to_vector
          Vector[value_x, value_y, value_z]
        end
      end
    end
  end
end
