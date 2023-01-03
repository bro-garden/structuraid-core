module Elements
  class Base
    def initialize(number:, material:)
      @diameter = diameter.to_f
      @number = number
      @material = material
      @start_hook = nil
      @end_hook = nil

      rebar_data = DB::Base::STANDARD_REBAR.find { |bar_data| bar_data['number'] == number }
      @diameter = rebar_data['diameter'].to_f
    end
  end
end
