require 'engineering/base'

module Engineering
  class Vector < Base
    attr_accessor :value_x, :value_y, value_z

    def initialize(value_x:, value_y:, value_z:)
      @value_x = value_x.to_f
      @value_y = value_y.to_f
      @value_z = value_z.to_f
    end

    def magnitude
      Math.sqrt(value_x**2 + value_y**2 + value_z**2)
    end
  end
end
