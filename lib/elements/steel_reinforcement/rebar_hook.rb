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

    end
  end
end
