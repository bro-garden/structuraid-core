require 'engineering/base'

module Engineering
  class Vector < Base
    attr_accessor :value_i, :value_j, :value_k

    def self.based_on_relative_location(location:)
      new(
        value_i: location.value_1,
        value_j: location.value_2,
        value_k: location.value_3
      )
    end

    def self.with_value(value:, direction:)
      new(
        value_i: value.to_f * direction[0],
        value_j: value.to_f * direction[1],
        value_k: value.to_f * direction[2]
      )
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

      [
        @value_i / vector_magnitude,
        @value_j / vector_magnitude,
        @value_k / vector_magnitude
      ]
    end

    def -(other)
      Engineering::Vector.new(
        value_i: value_i - other.value_i,
        value_j: value_j - other.value_j,
        value_k: value_k - other.value_k
      )
    end
  end
end
