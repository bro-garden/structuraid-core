module Elements
  class Footing
    attr_accessor :length_1, :length_2, :height, :material, :cover_lateral, :cover_top, :cover_bottom
    attr_reader :longitudinal_top_reinforcement_length_1,
                :longitudinal_bottom_reinforcement_length_1,
                :longitudinal_top_reinforcement_length_2,
                :longitudinal_bottom_reinforcement_length_2

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

    private

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
