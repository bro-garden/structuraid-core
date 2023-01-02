require './db/base'
require './lib/materials/steel'

module Elements
  class Rebar < Materials::Steel
    MAX_YIELD_STRESS = 550.to_f

    attr_reader :diameter, :yield_stress, :number, :hooks_class, :elastic_module, :start_hook, :end_hook

    def self.build_by_standard(number:, yield_stress:)
      rebar_data = DB::Base::STANDARD_REBAR.find { |bar_data| bar_data['number'] == number }

      @number = number

      new(
        yield_stress:,
        diameter: rebar_data['diameter'],
        elastic_module: nil
      )
    end

    def initialize(yield_stress:, elastic_module:, diameter:)
      @diameter = diameter.to_f
      @start_hook = nil
      @end_hook = nil

      super(yield_stress:, elastic_module:)
    end

    def design_yield_stress
      [yield_stress, MAX_YIELD_STRESS].min
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
