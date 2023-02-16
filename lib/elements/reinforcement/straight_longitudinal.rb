require 'elements/reinforcement/base'
require 'elements/reinforcement/layout'

module Elements
  module Reinforcement
    class StraightLongitudinal < Base
      def initialize(z_base:)
        @z_base = z_base.to_f
        @layouts = []
      end

      def add_layout(start_location:, end_location:)
        start_location.value_z = @z_base
        end_location.value_z = @z_base
        id = @layouts.empty? ? 1 : @layouts.last.id
        @layouts << Elements::Reinforcement::Layout.new(start_location, end_location, id)
      end

      def add(number_of_rebars:, rebar:, length:)
        layout = available_layout
        layout.add_or_modify(number_of_rebars, rebar, length)
      end

      def change(id_of_layout_to_change:, number_of_rebars:, rebar:)
        layout = find(id_of_layout_to_change)
        layout.add_or_modify(number_of_rebars, rebar)
      end

      private

      def available_layout
        @layouts.find(&:available?)
      end

      def find(id_of_layout_to_change)
        @layouts.find { |existing_layout| existing_layout.id == id_of_layout_to_change }
      end
    end
  end
end
