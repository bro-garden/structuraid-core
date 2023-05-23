module StructuraidCore
  module Elements
    # A footing is a structural element that transfers load from a column to the soil.
    class Footing
      attr_reader :length_1, :length_2, :height, :material, :cover_lateral, :cover_top, :cover_bottom,
                  :longitudinal_top_reinforcement_length_1,
                  :longitudinal_bottom_reinforcement_length_1,
                  :longitudinal_top_reinforcement_length_2,
                  :longitudinal_bottom_reinforcement_length_2,
                  :coordinates_system

      VALID_SECTIONS = %i[length_1 length_2].freeze

      # @param length_1 [Float] The length of the footing in the direction of the main section
      # @param length_2 [Float] The length of the footing in the direction perpendicular to the main section
      # @param height [Float] The height of the footing
      # @param material [Materials::Concrete] The material of the footing. It must be concrete
      # @param cover_lateral [Float] The lateral cover of the footing
      # @param cover_top [Float] The top cover of the footing
      # @param cover_bottom [Float] The bottom cover of the footing
      # @param longitudinal_top_reinforcement_length_1 [Reinforcement::StraightLongitudinalLayer] The longitudinal reinforcement in the direction of the main section
      # @param longitudinal_bottom_reinforcement_length_1 [Reinforcement::StraightLongitudinalLayer] The longitudinal reinforcement in the direction of the main section
      # @param longitudinal_top_reinforcement_length_2 [Reinforcement::StraightLongitudinalLayer] The longitudinal reinforcement in the direction perpendicular to the main section
      # @param longitudinal_bottom_reinforcement_length_2 [Reinforcement::StraightLongitudinalLayer] The longitudinal reinforcement in the direction perpendicular to the main section
      #
      # @return [Footing] the footing
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

      # Computes the horizontal area of the footing
      # @return [Float] The horizontal area of the footing
      def horizontal_area
        length_1 * length_2
      end

      # Computes the effective height of the footing for each direction and for either top or bottom reinforcement
      # @param section_direction [Symbol] The direction of the section. See VALID_SECTIONS
      # @param above_middle [Boolean] Whether the reinforcement is above the middle of the footing
      # @return [Float] The effective height of the footing
      def effective_height(section_direction:, above_middle:)
        case section_direction
        when :length_1
          length_1_section_effective_area(above_middle:)
        when :length_2
          length_2_section_effective_area(above_middle:)
        end
      end

      # Sets the coordinates system of the footing
      # @param coordinates_system [Engineering::Locations::CoordinatesSystem] A coordinates system instance
      # @return [Engineering::Locations::CoordinatesSystem] The coordinates system of the footing
      def add_coordinates_system(coordinates_system)
        @coordinates_system = coordinates_system
      end

      # Adds a column's location to the footing. If the column's location is already in the footing's coordinates system, it returns the existing location.
      # @param column_location [Engineering::Locations::Absolute] The column's absolute location
      # @param column_label [String, Symbol] The column's label
      # @return [Engineering::Locations::Relative] The column's relative location
      def find_or_add_column_location(column_location, column_label)
        label = "column_#{column_label}"
        relative_location_vector = column_location.to_vector - coordinates_system.anchor_location.to_vector
        coordinates_system.find_or_add_location_from_vector(relative_location_vector, label:)
      end

      # Computes the vertices location of the footing's perimeter horizontally and adds them to the footing's coordinates system
      def add_vertices_location
        vertices_locations_vectors.each do |label, vector|
          coordinates_system.find_or_add_location_from_vector(vector, label:)
        end
      end

      # Evaluates if a relative location is inside the footing's perimeter. It works only for horizontal locations (z = 0)
      # @param location [Engineering::Locations::Relative] The relative location to evaluate
      # @return [Boolean] Whether the location is inside the footing's perimeter
      def inside_me?(location)
        inside_axis_2 = location.value_2 >= -0.5 * length_2 && location.value_2 <= 0.5 * length_2
        inside_axis_1 = location.value_1 >= -0.5 * length_1 && location.value_1 <= 0.5 * length_1

        inside_axis_1 && inside_axis_2
      end

      def width(section_direction:)
        return @length_1 if section_direction == :length_2

        @length_2
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
          return @height - cover_bottom unless @longitudinal_top_reinforcement_length_1

          @longitudinal_top_reinforcement_length_1.centroid_height
        else
          return @height - cover_top unless @longitudinal_bottom_reinforcement_length_1

          @height - @longitudinal_bottom_reinforcement_length_1.centroid_height
        end
      end

      def length_2_section_effective_area(above_middle:)
        if above_middle
          return @height - cover_bottom unless @longitudinal_top_reinforcement_length_2

          @longitudinal_top_reinforcement_length_2.centroid_height
        else
          return @height - cover_top unless @longitudinal_bottom_reinforcement_length_2

          @height - @longitudinal_bottom_reinforcement_length_2.centroid_height
        end
      end
    end
  end
end
