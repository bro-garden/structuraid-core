module StructuraidCore
  module Elements
    # This module is used to compute the reinforcement ratio of a layered reinforced element, such as a footing or a slab.
    #
    # A layered reinforced element is an element that has a top and a bottom reinforcement layer, in both directios: length_1 and lenght_2.
    module LayeredReinforcedElements
      # Returns the reinforcement ratio for the given direction and whether the reinforcement is above the middle of the layered element
      # @param direction [Symbol] The direction of the working section
      # @param above_middle [Boolean] Whether the reinforcement is above the middle of the footing
      # @return [Float] The reinforcement ratio
      def reinforcement_ratio(direction:, above_middle:)
        case direction
        when :length_1
          reinforcement_ratio_length_1(above_middle:)
        when :length_2
          reinforcement_ratio_length_2(above_middle:)
        end
      end

      # Adds the reinforcement ratio isntance for the given direction and whether the reinforcement is above the middle of the layered element, and returns it
      # @param direction [Symbol] The direction of the working section
      # @return [Float] The reinforcement ratio
      # @param above_middle [Boolean] Whether the reinforcement is above the middle of the footing
      def add_longitudinal_reinforcement(reinforcement, direction, above_middle: false)
        if direction == :length_1
          self.longitudinal_top_reinforcement_length_1 = reinforcement if above_middle
          self.longitudinal_bottom_reinforcement_length_1 = reinforcement unless above_middle
        else
          self.longitudinal_top_reinforcement_length_2 = reinforcement if above_middle
          self.longitudinal_bottom_reinforcement_length_2 = reinforcement unless above_middle
        end
      end

      private

      def length_1_section_effective_area(above_middle:)
        if above_middle
          return height - cover_bottom unless longitudinal_top_reinforcement_length_1

          longitudinal_top_reinforcement_length_1.centroid_height
        else
          return height - cover_top unless longitudinal_bottom_reinforcement_length_1

          height - longitudinal_bottom_reinforcement_length_1.centroid_height
        end
      end

      def length_2_section_effective_area(above_middle:)
        if above_middle
          return height - cover_bottom unless longitudinal_top_reinforcement_length_2

          longitudinal_top_reinforcement_length_2.centroid_height
        else
          return height - cover_top unless longitudinal_bottom_reinforcement_length_2

          height - longitudinal_bottom_reinforcement_length_2.centroid_height
        end
      end

      def reinforcement_ratio_length_1(above_middle:)
        return reinforcement_ratio_length_1_top(above_middle) if above_middle

        reinforcement_ratio_length_1_bottom(above_middle)
      end

      def reinforcement_ratio_length_1_top(above_middle)
        return if longitudinal_top_reinforcement_length_1.nil?
        return 0 if longitudinal_top_reinforcement_length_1.empty?

        reinforcement = longitudinal_top_reinforcement_length_1.area

        section_direction = :length_1
        effective_area = width(section_direction) * effective_height(section_direction:, above_middle:)
        reinforcement / effective_area
      end

      def reinforcement_ratio_length_1_bottom(above_middle)
        return if longitudinal_bottom_reinforcement_length_1.nil?
        return 0 if longitudinal_bottom_reinforcement_length_1.empty?

        reinforcement = longitudinal_bottom_reinforcement_length_1.area

        section_direction = :length_1
        effective_area = width(section_direction) * effective_height(section_direction:, above_middle:)
        reinforcement / effective_area
      end

      def reinforcement_ratio_length_2(above_middle:)
        return reinforcement_ratio_length_2_top(above_middle) if above_middle

        reinforcement_ratio_length_2_bottom(above_middle)
      end

      def reinforcement_ratio_length_2_top(above_middle)
        return if longitudinal_top_reinforcement_length_2.nil?
        return 0 if longitudinal_top_reinforcement_length_2.empty?

        reinforcement = longitudinal_top_reinforcement_length_2.area

        section_direction = :length_2
        effective_area = width(section_direction) * effective_height(section_direction:, above_middle:)
        reinforcement / effective_area
      end

      def reinforcement_ratio_length_2_bottom(above_middle)
        return if longitudinal_bottom_reinforcement_length_2.nil?
        return 0 if longitudinal_bottom_reinforcement_length_2.empty?

        reinforcement = longitudinal_bottom_reinforcement_length_2.area

        section_direction = :length_2
        effective_area = width(section_direction) * effective_height(section_direction:, above_middle:)
        reinforcement / effective_area
      end
    end
  end
end
