require 'matrix'

module StructuraidCore
  module Engineering
    module Locations
      class Relative < Base
        attr_reader :value_1, :value_2, :value_3

        def self.from_matrix(matrix)
          new(
            value_1: matrix[0, 0],
            value_2: matrix[1, 0],
            value_3: matrix[2, 0]
          )
        end

        def initialize(value_1:, value_2:, value_3:)
          @value_1 = value_1.to_f
          @value_2 = value_2.to_f
          @value_3 = value_3.to_f
        end

        def to_matrix
          Matrix.column_vector(
            [
              value_1,
              value_2,
              value_3
            ]
          )
        end

        def update_from_matrix(matrix)
          @value_1 = matrix[0, 0]
          @value_2 = matrix[1, 0]
          @value_3 = matrix[2, 0]
        end

        def to_vector
          Vector[value_1, value_2, value_3]
        end
      end
    end
  end
end
