require 'db/base'
require 'elements/steel_reinforcement/base'

module Elements
  module SteelReinforcement
    class RebarHook < Base
      MIN180_HOOK_LENGTH = 60.to_f
      MIN_HOOK_LENGTH = 75.to_f

      attr_reader :angle, :length, :diameter

      def use_angle_of(angle)
        @angle = angle
        @length = calculate_length
      end

      private

      def calculate_length
        case angle
        when 90
          [12 * diameter, MIN_HOOK_LENGTH].max
        when 180
          [4 * diameter, MIN180_HOOK_LENGTH].max
        else
          [6 * diameter, MIN_HOOK_LENGTH].max
        end
      end
    end
  end
end
