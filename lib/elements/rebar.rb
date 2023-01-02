require 'db/base'
require 'elements/base'

module Elements
  class Rebar < Base
    attr_reader :diameter, :number, :start_hook, :end_hook, :material

    def initialize(number:, material:)
      @diameter = diameter.to_f
      @number = number
      @material = material
      @start_hook = nil
      @end_hook = nil

      rebar_data = DB::Base::STANDARD_REBAR.find { |bar_data| bar_data['number'] == number }
      @diameter = rebar_data['diameter'].to_f
    end

    def area
      rebar_area = Math::PI * (diameter**2) / 4
      rebar_area.to_f
    end

    def perimeter
      rebar_perimeter = Math::PI * diameter
      rebar_perimeter.to_f
    end

    def add_start_hook_of(hook, angle)
      @start_hook = hook
      @start_hook.setup_properties(diameter, angle)

      @start_hook
    end

    def add_end_hook_of(hook, angle)
      @end_hook = hook
      @end_hook.setup_properties(diameter, angle)

      @end_hook
    end

    def delete_start_hook
      @start_hook = nil
    end

    def delete_end_hook
      @end_hook = nil
    end
  end
end
