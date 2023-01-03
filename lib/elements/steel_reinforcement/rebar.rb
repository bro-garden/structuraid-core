require 'db/base'
require 'elements/steel_reinforcement/base'

module Elements
  module SteelReinforcement
    class Rebar < Base
      attr_reader :start_hook, :end_hook

      def initialize(number:, material:, standard_rebars: DB::Base)
        @start_hook = nil
        @end_hook = nil

        super(number:, material:, standard_rebars:)
      end

      def area
        rebar_area = Math::PI * (diameter**2) / 4
        rebar_area.to_f
      end

      def perimeter
        rebar_perimeter = Math::PI * diameter
        rebar_perimeter.to_f
      end

      def add_start_hook(hook)
        @start_hook = hook
      end

      def add_end_hook(hook)
        @end_hook = hook
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
