require 'elements/reinforcement/base'
require 'elements/reinforcement/straight_longitudinal_layer'
require 'errors/reinforcement/empty_layers'

module Elements
  module Reinforcement
    class StraightLongitudinal < Base
      attr_reader :layers

      def initialize(distribution_direction:, above_middle: false)
        @above_middle = above_middle
        @layers = []
        @distribution_direction = distribution_direction
      end

      def add_layer(start_location:, end_location:, amount_of_rebars:, rebar:)
        new_layer = Elements::Reinforcement::StraightLongitudinalLayer.new(
          start_location:,
          end_location:,
          amount_of_rebars:,
          rebar:,
          distribution_direction: @distribution_direction
        )

        new_layer.reposition(above_middle: @above_middle)
        @layers << new_layer

        new_layer
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
    end
  end
end
