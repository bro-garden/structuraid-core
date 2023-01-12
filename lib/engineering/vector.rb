require 'engineering/base'

module Engineering
  class Vector < Base
    attr_accessor :value_x, :value_y, :value_z

    def self.with_value(value:, direction:)
      new(
        value_x: value.to_f * direction[0],
        value_y: value.to_f * direction[1],
        value_z: value.to_f * direction[2]
      )
    end

    def initialize(value_x:, value_y:, value_z:)
      @value_x = value_x.to_f
      @value_y = value_y.to_f
      @value_z = value_z.to_f
    end

    def magnitude
      Math.sqrt(value_x**2 + value_y**2 + value_z**2)
    end

    def direction
      vector_magnitude = magnitude

      [
        @value_x / vector_magnitude,
        @value_y / vector_magnitude,
        @value_z / vector_magnitude
      ]
    end
  end
end
