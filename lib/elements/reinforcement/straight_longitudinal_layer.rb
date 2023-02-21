require 'elements/reinforcement/base'
require 'errors/reinforcement/invalid_distribution_direction'

module Elements
  module Reinforcement
    class StraightLongitudinalLayer < Base
      attr_accessor :start_location, :end_location, :rebar, :id

      VALID_DIRECTIONS = %i[length_1 length_2 length_3].freeze

      def initialize(
        start_location:,
        end_location:,
        amount_of_rebars:,
        rebar:,
        id:,
        distribution_direction:
      )
        if VALID_DIRECTIONS.none?(distribution_direction)
          raise Elements::Reinforcement::InvalidDistributionDirection.new(distribution_direction, VALID_DIRECTIONS)
        end

        @id = id
        @start_location = start_location
        @end_location = end_location
        @amount_of_rebars = amount_of_rebars
        @rebar = rebar
        @distribution_direction = distribution_direction
      end

      def modify(number_of_rebars:, rebar:)
        current_rebar = @rebar
        @number_of_rebars = number_of_rebars
        @rebar = rebar


      end

      def area
        @number_of_rebars * @rebar.area
      end

      def diameter
        @rebar.diameter
      end

      def length
        delta = deltas_start_to_end

        delta[0] = 0 if @distribution_direction == :length_1
        delta[1] = 0 if @distribution_direction == :length_2

        Math.sqrt(delta[0]**2 + delta[1]**2 + delta[2]**2)
      end

      private

      def deltas_start_to_end
        [
          end_location.value_1 - start_location.value_1,
          end_location.value_2 - start_location.value_2,
          end_location.value_3 - start_location.value_3
        ]
      end
    end
  end
end
