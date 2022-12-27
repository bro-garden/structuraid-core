require './db/base'
require_relative 'base'
require 'byebug'

module Material
  class Rebar < Base
    MAX_FY = 550
    STANDARD_E_MODULE = 200_000

    attr_reader :diameter

    def self.build_by_standard(rebar_number:, f_limit:)
      rebar_data = DB::STANDARD_REBAR[rebar_number]
      @number = rebar_number

      new(
        f_limit:,
        e_module: STANDARD_E_MODULE,
        diameter: rebar_data['diameter']
      )
    end

    def initialize(f_limit:, e_module:, diameter:)
      @diameter = diameter
      @e_module = e_module || STANDARD_E_MODULE
      super(f_limit:, e_module: @e_module)
    end

    def f_y
      [@f_limit, MAX_FY].min
    end

    def area
      rebar_area = Math::PI * (@diameter**2) / 4
      rebar_area.to_i
    end

    def perimeter
      rebar_perimeter = Math::PI * @diameter
      rebar_perimeter.round(1)
    end

    def to_s
      "##{@number}"
    end
  end
end
