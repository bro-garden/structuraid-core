require 'elements/reinforcement/base'

module Elements
  module Reinforcement
    class RebarLayer < Base
      attr_accessor :start_location, :end_location, :rebar, :id

      def initialize(start_location:, end_location:, id:)
        @id = id
        @start_location = start_location
        @end_location = end_location
        @number_of_rebars = nil
        @rebar = nil
        @length = nil
      end

      def available?
        @number_of_rebars.nil? && @rebar.nil?
      end

      def add_or_modify(number_of_rebars:, rebar:, length:)
        @length = length
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
