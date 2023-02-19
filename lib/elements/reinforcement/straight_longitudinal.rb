require 'elements/reinforcement/base'
require 'elements/reinforcement/straight_longitudinal_layer'

module Elements
  module Reinforcement
    class StraightLongitudinal < Base
      def initialize(z_base:, direction: 1)
        @z_base = z_base
        @direction = direction
        @layers = []
      end

      def modify_z_base(z_base:)
        @z_base = z_base.to_f
        update_z_base_of_layers unless @layers.empty?
      end

      def add_layer(start_location:, end_location:, number_of_rebars:, rebar:)
        start_location.value_3 = @z_base
        end_location.value_3 = @z_base
        id = @layers.empty? ? 1 : @layers.last.id
        @layers << Elements::Reinforcement::StraightLongitudinalLayer.new(
          start_location:,
          end_location:,
          number_of_rebars:,
          rebar:,
          id:
        )

        @layers.last
      end

      def change(id_of_layer_to_change:, number_of_rebars:, rebar:)
        straight_longitudinal_layer = find(id_of_layer_to_change)
        straight_longitudinal_layer.modify(number_of_rebars:, rebar:)

        straight_longitudinal_layer
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
    end
  end
end
