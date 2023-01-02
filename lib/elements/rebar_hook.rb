require './db/base'
require './lib/materials/steel'

module Elements
  class RebarHook < Materials::Steel
    MAX_FY = 550.to_f
    MIN180_HOOK_LENGTH = 60.to_f
    MIN_HOOK_LENGTH = 75.to_f

    attr_reader :angle, :length, :diameter

    def initialize(yield_stress:, elastic_module:, diameter:)
      @diameter = diameter
      @length = nil
      @angle = nil

      super(
        yield_stress:,
        elastic_module:
      )
    end

    def use_angle_of(angle)
      @angle = angle
      @length = calculate_length
    end

    private

    def calculate_length
      case angle
      when 90
        [12 * diameter, MIN_HOOK_LENGTH].max
      when 180
        [4 * diameter, MIN180_HOOK_LENGTH].max
      else
        [6 * diameter, MIN_HOOK_LENGTH].max
      end
    end
  end
end
