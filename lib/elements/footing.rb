module Elements
  class Footing
    attr_accessor :step, :length_x, :length_y, :height, :material

    def initialize(length_x:, length_y:, height:, concrete:, step: 100)
      @length_x = length_x.to_f
      @length_y = length_y.to_f
      @height = height.to_f
      @step = step.to_f
      @material = concrete
    end

    def incrase_height_by_step
      @height = height + step
    end

    def incrase_length_x_by_step
      @length_x = length_x.to_f + step
    end

    def incrase_length_y_by_step
      @length_y = length_y.to_f + step
    end

    def horizontal_area
      length_x * length_y
    end
  end
end
