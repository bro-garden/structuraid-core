require 'elements/reinforcement/base'
require 'elements/reinforcement/straight_longitudinal_layer'
require 'errors/reinforcement/empty_layers'

module Elements
  module Reinforcement
    class StraightLongitudinal < Base
      attr_accessor :layers

      def initialize(distribution_direction:, above_middle: false)
        @above_middle = above_middle
        @layers = []
        @distribution_direction = distribution_direction
      end

      def add_layer(start_location:, end_location:, number_of_rebars:, rebar:)
        id = @layers.empty? ? 1 : @layers.last.id
        start_location = modify_value_3_of_location(start_location, 0.5 * rebar.diameter)
        end_location = modify_value_3_of_location(end_location, 0.5 * rebar.diameter)
        @layers << Elements::Reinforcement::StraightLongitudinalLayer.new(
          start_location:,
          end_location:,
          number_of_rebars:,
          rebar:,
          id:,
          distribution_direction: @distribution_direction
        )

        @layers.last
      end

      def change(id_of_layer_to_change:, number_of_rebars:, rebar:, start_location: nil, end_location: nil)
        straight_longitudinal_layer = find(id_of_layer_to_change)
        straight_longitudinal_layer.modify(
          number_of_rebars:,
          rebar:,
          start_location:,
          end_location:
        )

        straight_longitudinal_layer
      end

      def centroid_height
        if @layers.empty?
          raise Elements::Reinforcement::EmptyLayers, "can't complete centroid height calculation"
        end

        inertia = 0

        @layers.each do |layer|
          layer_centroid_height = @z_base + 0.5 * layer.diameter * @direction
          inertia += layer.area * layer_centroid_height
        end

        inertia / area
      end

      def area
        @layers.map(&:area).reduce(:+)
      end

      private

      def update_z_base_of_layers
        @layers.each do |straight_longitudinal_layer|
          straight_longitudinal_layer.start_location.value_3 = @z_base
          straight_longitudinal_layer.end_location.value_3 = @z_base
        end
      end

      def find(id_of_layer_to_change)
        @layers.find do |existing_straight_longitudinal_layer|
          existing_straight_longitudinal_layer.id == id_of_layer_to_change
        end
      end

      def modify_value_3_of_location(location, offset)
        location.value_3 = above_middle ? location.value_3 - offset : location.value_3 + offset
      end
    end
  end
end
