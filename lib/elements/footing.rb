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
      cover_bottom:
    )
      @length_1 = length_1.to_f
      @length_2 = length_2.to_f
      @height = height.to_f
      @material = material
      @cover_lateral = cover_lateral.to_f
      @cover_top = cover_top.to_f
      @cover_bottom = cover_bottom.to_f
    end

    def horizontal_area
      length_1 * length_2
    end
  end
end
