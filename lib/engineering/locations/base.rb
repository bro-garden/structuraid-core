module Engineering
  module Locations
    class Base
      attr_accessor :value_x, :value_y, :value_z

      def initialize(value_x:, value_y:, value_z:)
        @value_x = value_x
        @value_y = value_y
        @value_z = value_z
      end
    end
  end
end
