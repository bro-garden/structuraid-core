require_relative 'base'

module Material
  class Rebar < Base
    MAX_FY = 550

    def initialize(f_limit:, e_module:, diameter:)
      @diameter = diameter
      super(f_limit:, e_module:)
    end

    def f_y
      [@f_limit, MAX_FY].min
    end

    def area
      Math::PI * (@diameter**2) / 4
    end
  end
end
