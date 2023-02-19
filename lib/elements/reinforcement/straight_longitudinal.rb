require 'elements/reinforcement/base'
require 'elements/reinforcement/rebar_layer'

module Elements
  module Reinforcement
    class StraightLongitudinal < Base
      def initialize(z_base:, direction: 1)
        @z_base = z_base
        @direction = direction
        @rebar_layers = []
      end

      def modify_z_base(z_base:)
        @z_base = z_base.to_f
        update_z_base_of_rebar_layers unless @rebar_layers.empty?
      end

      def add_rebar_layer(start_location:, end_location:)
        start_location.value_z = @z_base
        end_location.value_z = @z_base
        id = @rebar_layers.empty? ? 1 : @rebar_layers.last.id
        @rebar_layers << Elements::Reinforcement::RebarLayer.new(start_location:, end_location:, id:)
      end

      def add(number_of_rebars:, rebar:, length:)
        rebar_layer = available_rebar_layer
        rebar_layer.add_or_modify(number_of_rebars:, rebar:, length:)

        rebar_layer
      end

      def change(id_of_rebar_layer_to_change:, number_of_rebars:, rebar:, length:)
        rebar_layer = find(id_of_rebar_layer_to_change)
        rebar_layer.add_or_modify(number_of_rebars:, rebar:, length:)

        rebar_layer
      end

      private

      def update_z_base_of_rebar_layers
        @rebar_layers.each do |rebar_layer|
          rebar_layer.start_location.value_z = @z_base
          rebar_layer.end_location.value_z = @z_base
        end
      end

      def available_rebar_layer
        @rebar_layers.find(&:available?)
      end

      def find(id_of_rebar_layer_to_change)
        @rebar_layers.find { |existing_rebar_layer| existing_rebar_layer.id == id_of_rebar_layer_to_change }
      end
    end
  end
end
