module StructuraidCore
  module Elements
    class Footing < Base
      attr_accessor :length_1, :length_2, :height, :material, :cover_lateral, :cover_top, :cover_bottom
      attr_reader :longitudinal_top_reinforcement_length_1,
                  :longitudinal_bottom_reinforcement_length_1,
                  :longitudinal_top_reinforcement_length_2,
                  :longitudinal_bottom_reinforcement_length_2,
                  :coordinates_system

      VALID_SECTIONS = %i[length_1 length_2].freeze

      def initialize(
        length_1:,
        length_2:,
        height:,
        material:,
        cover_lateral:,
        cover_top:,
        cover_bottom:,
        longitudinal_top_reinforcement_length_1: nil,
        longitudinal_bottom_reinforcement_length_1: nil,
        longitudinal_top_reinforcement_length_2: nil,
        longitudinal_bottom_reinforcement_length_2: nil
      )
        @length_1 = length_1.to_f
        @length_2 = length_2.to_f
        @height = height.to_f
        @material = material
        @cover_lateral = cover_lateral.to_f
        @cover_top = cover_top.to_f
        @cover_bottom = cover_bottom.to_f
        @longitudinal_top_reinforcement_length_1 = longitudinal_top_reinforcement_length_1
        @longitudinal_bottom_reinforcement_length_1 = longitudinal_bottom_reinforcement_length_1
        @longitudinal_top_reinforcement_length_2 = longitudinal_top_reinforcement_length_2
        @longitudinal_bottom_reinforcement_length_2 = longitudinal_bottom_reinforcement_length_2
        @main_section = :length_1
      end

      def horizontal_area
        @length_1 * @length_2
      end

      def effective_height(section_direction:, above_middle:)
        case section_direction
        when :length_1
          length_1_section_effective_area(above_middle:)
        when :length_2
          length_2_section_effective_area(above_middle:)
        end
      end

      def add_coordinates_system(coordinates_system)
        @coordinates_system = coordinates_system
      end

      def find_or_add_column_location(column_location, column_label)
        label = "column_#{column_label}"
        relative_location_vector = column_location.to_vector - coordinates_system.anchor_location.to_vector
        coordinates_system.find_or_add_location_from_vector(relative_location_vector, label:)
      end

      def add_vertices_location
        vertices_locations_vectors.each do |label, vector|
          coordinates_system.find_or_add_location_from_vector(vector, label:)
        end
      end

      def inside_me?(location)
        inside_axis_2 = location.value_2 >= -0.5 * length_2 && location.value_2 <= 0.5 * length_2
        inside_axis_1 = location.value_1 >= -0.5 * length_1 && location.value_1 <= 0.5 * length_1

        inside_axis_1 && inside_axis_2
      end

      private

      def vertices_locations_vectors
        half_length_1 = 0.5 * length_1
        half_length_2 = 0.5 * length_2

        {
          'vertex_top_right' => Vector[half_length_1, half_length_2, 0],
          'vertex_top_left' => Vector[-half_length_1, half_length_2, 0],
          'vertex_bottom_left' => Vector[-half_length_1, -half_length_2, 0],
          'vertex_bottom_right' => Vector[half_length_1, -half_length_2, 0]
        }
      end

      def aspect_ratio
        @length_1 / @length_2
      end

      def length_1_section_effective_area(above_middle:)
        if above_middle
          return nil unless @longitudinal_top_reinforcement_length_1

          @longitudinal_top_reinforcement_length_1.centroid_height
        else
          return nil unless @longitudinal_bottom_reinforcement_length_1

          @height - @longitudinal_bottom_reinforcement_length_1.centroid_height
        end
      end

      def length_2_section_effective_area(above_middle:)
        if above_middle
          return nil unless @longitudinal_top_reinforcement_length_2

          @longitudinal_top_reinforcement_length_2.centroid_height
        else
          return nil unless @longitudinal_bottom_reinforcement_length_2

          @height - @longitudinal_bottom_reinforcement_length_2.centroid_height
        end
      end
    end
  end
end
