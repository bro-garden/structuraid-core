require 'elements/reinforcement/base'

module Elements
  module Reinforcement
    class Layout < Base
      def initialize(start_location:, end_location:, id:)
        @id = id
        @start_location = start_location
        @end_location = end_location
        @number_of_rebars = nil
        @rebar = nil
      end

      def available?
        @number_of_rebars.nil? && @rebar.nil?
      end

      def add_or_modify(number_of_rebars, rebar)
        @number_of_rebars = number_of_rebars
        @rebar = rebar
      end
    end
  end
end
