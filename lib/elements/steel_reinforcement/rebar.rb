require 'db/base'
require 'elements/steel_reinforcement/base'

module Elements
  module SteelReinforcement
    class Rebar < Base
      attr_reader :diameter, :number, :start_hook, :end_hook, :material

      def area
        rebar_area = Math::PI * (diameter**2) / 4
        rebar_area.to_f
      end

      def perimeter
        rebar_perimeter = Math::PI * diameter
        rebar_perimeter.to_f
      end

      def add_start_hook_of(hook, angle)
        @start_hook = hook
        @start_hook.use_angle_of(angle)

        @start_hook
      end

      def add_end_hook_of(hook, angle)
        @end_hook = hook
        @end_hook.use_angle_of(angle)

        @end_hook
      end

      def delete_start_hook
        @start_hook = nil
      end

      def delete_end_hook
        @end_hook = nil
      end
    end
  end
end