require 'elements/reinforcement/base'
require 'elements/reinforcement/layout'

module Elements
  module Reinforcement
    class StraightLongitudinal < Base
      def initialize(z_base:, direction: 1)
        @z_base = z_base
        @direction = direction
        @layouts = []
      end

      def modify_z_base(z_base:)
        @z_base = z_base.to_f
        update_z_base_of_layouts unless @layouts.empty?
      end

      def add_layout(start_location:, end_location:)
        start_location.value_z = @z_base
        end_location.value_z = @z_base
        id = @layouts.empty? ? 1 : @layouts.last.id
        @layouts << Elements::Reinforcement::Layout.new(start_location:, end_location:, id:)
      end

      def add(number_of_rebars:, rebar:, length:)
        layout = available_layout
        layout.add_or_modify(number_of_rebars:, rebar:, length:)

        layout
      end

      def change(id_of_layout_to_change:, number_of_rebars:, rebar:, length:)
        layout = find(id_of_layout_to_change)
        layout.add_or_modify(number_of_rebars:, rebar:, length:)

        layout
      end

      private

      def update_z_base_of_layouts
        @layouts.each do |layout|
          layout.start_location.value_z = @z_base
          layout.end_location.value_z = @z_base
        end
      end

      def available_layout
        @layouts.find(&:available?)
      end

      def find(id_of_layout_to_change)
        @layouts.find { |existing_layout| existing_layout.id == id_of_layout_to_change }
      end
    end
  end
end
