require 'db/base'
require 'elements/steel_reinforcement/base'

module Elements
  module SteelReinforcement
    class RebarHook < Base
      attr_reader :angle, :length

      def use_angle(angle)
        @angle = angle
        @length = calculate_length
      end

      private

      def calculate_length
        case angle
        when 90
          12 * diameter
        when 180
          4 * diameter
        else
          6 * diameter
        end
      end
    end
  end
end
