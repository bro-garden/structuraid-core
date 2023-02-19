require 'elements/reinforcement/base'

module Elements
  module Reinforcement
    class StraightLongitudinalLayer < Base
      attr_accessor :start_location, :end_location, :rebar, :id

      def initialize(
        start_location:,
        end_location:,
        number_of_rebars:,
        rebar:,
        id:
      )
        @id = id
        @start_location = start_location
        @end_location = end_location
        @number_of_rebars = number_of_rebars
        @rebar = rebar
      end

      def modify(number_of_rebars:, rebar:)
        @number_of_rebars = number_of_rebars
        @rebar = rebar
      end

      def area
        @number_of_rebars * @rebar.area
      end

      def diameter
        @rebar.diameter
      end
    end
  end
end
