require 'elements/reinforcement/base'
require 'elements/reinforcement/straight_longitudinal_layer'
require 'errors/reinforcement/empty_layers'

module Elements
  module Reinforcement
    class StraightLongitudinal < Base
      def initialize(distribution_direction:, above_middle: false)
        @above_middle = above_middle
        @layers = []
        @distribution_direction = distribution_direction
      end

      def add_layer(start_location:, end_location:, amount_of_rebars:, rebar:)
        id = @layers.empty? ? 1 : @layers.last.id

        new_layer = Elements::Reinforcement::StraightLongitudinalLayer.new(
          start_location:,
          end_location:,
          amount_of_rebars:,
          rebar:,
          id:,
          distribution_direction: @distribution_direction
        )

        new_layer.reposition(above_middle: @above_middle)
        @layers << new_layer

        new_layer
      end

      def change_layer_rebar_configuration(
        layer_id:,
        amount_of_new_rebars:,
        new_rebar:
      )
        straight_longitudinal_layer = find(layer_id)

        straight_longitudinal_layer.modify_rebar_configuration(
          amount_of_new_rebars:,
          new_rebar:,
          above_middle: @above_middle
        )

        straight_longitudinal_layer
      end

      def move_layer_by_its_axis_3(layer_id:, offset:)
        straight_longitudinal_layer = find(layer_id)
        straight_longitudinal_layer.reposition(above_middle: @above_middle, offset:)

        straight_longitudinal_layer
      end

      def centroid_height
        if @layers.empty?
          raise Elements::Reinforcement::EmptyLayers, "can't complete centroid height calculation"
        end

        inertia = 0
        total_area = 0

        @layers.each do |layer|
          total_area += layer.area
          inertia += layer.inertia
        end

        inertia / total_area
      end

      def area
        @layers.map(&:area).reduce(:+)
      end

      private

      def find(layer_id)
        @layers.find do |existing_straight_longitudinal_layer|
          existing_straight_longitudinal_layer.id == layer_id
        end
      end
    end
  end
end
