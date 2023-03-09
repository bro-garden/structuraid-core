require 'engineering/locations/base'

module Engineering
  module Locations
    class Relative < Base
      attr_accessor :value_1, :value_2, :value_3

      def self.absolute_location_relative_to(location_to_relativize:, reference_location:)
        new(
          value_1: location_to_relativize.value_x - reference_location.value_x,
          value_2: location_to_relativize.value_y - reference_location.value_y,
          value_3: location_to_relativize.value_z - reference_location.value_z
        )
      end

      def initialize(value_1:, value_2:, value_3:)
        @value_1 = value_1.to_f
        @value_2 = value_2.to_f
        @value_3 = value_3.to_f
      end
    end
  end
end
