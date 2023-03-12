require 'engineering/locations/base'
require 'engineering/array'

module Engineering
  module Locations
    class Absolute < Base
      attr_reader :value_x, :value_y, :value_z

      def initialize(value_x:, value_y:, value_z:)
        @value_x = value_x.to_f
        @value_y = value_y.to_f
        @value_z = value_z.to_f
      end

      def to_a
        Engineering::Array.new(
          [value_x],
          [value_y],
          [value_z]
        )
      end
    end
  end
end
