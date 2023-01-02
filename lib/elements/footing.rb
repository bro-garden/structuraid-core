module Elements
  class Footing
    attr_reader :concrete

    attr_accessor :step, :dimension1, :dimension2, :height

    def initialize(dimension1:, dimension2:, height:, concrete:, step: 100)
      @dimension1 = dimension1.to_f
      @dimension2 = dimension2.to_f
      @height = height.to_f
      @step = step.to_f
      @concrete = concrete
    end

    def change_concrete_to(concrete)
      @concrete = concrete
    end

    def incrase_height_by_step
      @height = height + step
    end

    def incrase_dimension1_by_step
      @dimension1 = dimension1.to_f + step
    end

    def incrase_dimension2_by_step
      @dimension2 = dimension2.to_f + step
    end

    def area
      dimension1 * dimension2
    end
  end
end
