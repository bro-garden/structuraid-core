require 'matrix'

module StructuraidCore
  module Engineering
    module Locations
      class Relative < Base
        attr_reader :label
        attr_accessor :value_1, :value_2, :value_3

        def self.from_vector(vector, label: nil)
          new(
            value_1: vector[0],
            value_2: vector[1],
            value_3: vector[2],
            label:
          )
        end

        def self.from_matrix(matrix, label: nil)
          new(
            value_1: matrix[0, 0],
            value_2: matrix[1, 0],
            value_3: matrix[2, 0],
            label:
          )
        end

        def initialize(value_1:, value_2:, value_3:, label: nil)
          @value_1 = value_1.to_f
          @value_2 = value_2.to_f
          @value_3 = value_3.to_f

          @label = label
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

        def update_from_vector(vector)
          @value_1 = vector[0]
          @value_2 = vector[1]
          @value_3 = vector[2]
        end

        def to_vector
          Vector[value_1, value_2, value_3]
        end
      end
    end
  end
end
