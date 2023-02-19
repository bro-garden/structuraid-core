require 'elements/reinforcement/base'
require 'elements/reinforcement/straight_longitudinal_layer'

module Elements
  module Reinforcement
    class StraightLongitudinal < Base
      def initialize(z_base:, direction: 1)
        @z_base = z_base
        @direction = direction
        @straight_longitudinal_layers = []
      end

      def modify_z_base(z_base:)
        @z_base = z_base.to_f
        update_z_base_of_straight_longitudinal_layers unless @straight_longitudinal_layers.empty?
      end

      def add_straight_longitudinal_layer(start_location:, end_location:, number_of_rebars:, rebar:)
        start_location.value_z = @z_base
        end_location.value_z = @z_base
        id = @straight_longitudinal_layers.empty? ? 1 : @straight_longitudinal_layers.last.id
        @straight_longitudinal_layers << Elements::Reinforcement::StraightLongitudinalLayer.new(
          start_location:,
          end_location:,
          number_of_rebars:,
          rebar:,
          id:
        )

        @straight_longitudinal_layers.last
      end

      def change(id_of_straight_longitudinal_layer_to_change:, number_of_rebars:, rebar:, length:)
        straight_longitudinal_layer = find(id_of_straight_longitudinal_layer_to_change)
        straight_longitudinal_layer.modify(number_of_rebars:, rebar:, length:)

        straight_longitudinal_layer
      end

      private

      def update_z_base_of_straight_longitudinal_layers
        @straight_longitudinal_layers.each do |straight_longitudinal_layer|
          straight_longitudinal_layer.start_location.value_3 = @z_base
          straight_longitudinal_layer.end_location.value_3 = @z_base
        end
      end

      def find(id_of_straight_longitudinal_layer_to_change)
        @straight_longitudinal_layers.find { |existing_straight_longitudinal_layer| existing_straight_longitudinal_layer.id == id_of_straight_longitudinal_layer_to_change }
      end
    end
  end
end
