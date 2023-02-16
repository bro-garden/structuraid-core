module Elements
  class Footing
    attr_reader :length_1, :length_2, :height, :material, :cover_lateral, :cover_top, :cover_bottom

    def initialize(
      length_1:,
      length_2:,
      height:,
      material:,
      cover_lateral:,
      cover_top:,
      cover_bottom:,
      longitudinal_top_reinforcement:,
      longitudinal_bottom_reinforcement:
    )
      @length_1 = length_1.to_f
      @length_2 = length_2.to_f
      @height = height.to_f
      @material = material
      @cover_lateral = cover_lateral.to_f
      @cover_top = cover_top.to_f
      @cover_bottom = cover_bottom.to_f
      @reinforcement_length_1 = nil
      @reinforcement_length_1 = nil
      @longitudinal_top_reinforcement = longitudinal_top_reinforcement
      @longitudinal_bottom_reinforcement = longitudinal_bottom_reinforcement
    end

    def horizontal_area
      length_1 * length_2
    end

    private

    def aspect_ratio
      @length_1 / @length_2
    end
  end
end
