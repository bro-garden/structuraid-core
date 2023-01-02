require './db/base'
require './lib/material/steel'

module Element
  class Rebar < Material::Steel
    MAX_STRENGTH_YIELD = 550
    STANDARD_E_MODULE = 200_000

    attr_reader :diameter, :strength_limit, :number

    def self.build_by_standard(number:, strength_limit:)
      rebar_data = DB::Base::STANDARD_REBAR[number]
      @number = number

      new(
        strength_limit:,
        e_module: STANDARD_E_MODULE,
        diameter: rebar_data['diameter']
      )
    end

    def initialize(strength_limit:, e_module:, diameter:)
      @diameter = diameter

      super(
        strength_limit:,
        e_module: e_module || STANDARD_E_MODULE
      )
    end

    def yield_strength
      [strength_limit, MAX_STRENGTH_YIELD].min
    end

    def area
      rebar_area = Math::PI * (diameter**2) / 4
      rebar_area.to_f
    end

    def perimeter
      rebar_perimeter = Math::PI * diameter
      rebar_perimeter.to_f
    end
  end
end
