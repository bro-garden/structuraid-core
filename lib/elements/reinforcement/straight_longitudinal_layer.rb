require 'elements/reinforcement/base'
require 'errors/reinforcement/invalid_distribution_direction'
require 'engineering/vector'

module Elements
  module Reinforcement
    class StraightLongitudinalLayer < Base
      attr_reader :start_location, :end_location, :rebar, :id, :amount_of_rebars

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

      def modify_rebar_configuration(
        amount_of_new_rebars:,
        new_rebar:,
        above_middle:
      )

        offset = (diameter - new_rebar.diameter) / 2
        offset *= -1 unless above_middle

        @amount_of_rebars = amount_of_new_rebars
        @rebar = new_rebar

        reposition(above_middle:, offset:)
        @rebar
      end

      def reposition(above_middle:, offset: nil)
        offset ||= 0.5 * diameter

        [@start_location, @end_location].each do |location|
          location.value_3 = above_middle ? location.value_3 - offset : location.value_3 + offset
        end
      end

      def area
        @amount_of_rebars * @rebar.area
      end

      def inertia
        area * centroid_height
      end

      def centroid_height
        @start_location.value_3
      end

      def diameter
        @rebar.diameter
      end

      def move_axis_3(offset:)
        @start_location.value_3 = @start_location.value_3 + offset
        @end_location.value_3 = @end_location.value_3 + offset
      end

      def length
        vector = length_vector

        vector.value_x = 0 if @distribution_direction == :length_1
        vector.value_y = 0 if @distribution_direction == :length_2
        vector.value_z = 0 if @distribution_direction == :length_3

        vector.magnitude
      end

      private

      def length_vector
        Engineering::Vector.new(
          value_x: end_location.value_1 - start_location.value_1,
          value_y: end_location.value_2 - start_location.value_2,
          value_z: end_location.value_3 - start_location.value_3
        )
      end
    end
  end
end
