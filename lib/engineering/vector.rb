require 'engineering/base'

module Engineering
  class Vector < Base
    attr_accessor :value_i, :value_j, :value_k

    class << self
      def based_on_location(location:)
        initialize_from_array(array: location.to_a)
      end

      def with_value(value:, direction:)
        new(
          value_i: value.to_f * direction[0],
          value_j: value.to_f * direction[1],
          value_k: value.to_f * direction[2]
        )
      end

      private

      def initialize_from_array(array:)
        new(
          value_i: array[0][0],
          value_j: array[1][0],
          value_k: array[2][0]
        )
      end
    end

    def initialize(value_i:, value_j:, value_k:)
      @value_i = value_i.to_f
      @value_j = value_j.to_f
      @value_k = value_k.to_f
    end

    def magnitude
      Math.sqrt(value_i**2 + value_j**2 + value_k**2)
    end

    def direction
      vector_magnitude = magnitude

      Engineering::Vector.new(
        @value_i / vector_magnitude,
        @value_j / vector_magnitude,
        @value_k / vector_magnitude
      )
    end

    def -(other)
      initialize_from_array(array: to_a - other.to_a)
    end

    def to_a
      Engineering::Array.new(
        [value_i],
        [value_j],
        [value_k]
      )
    end
  end
end
