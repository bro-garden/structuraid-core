require './db/base'
require_relative 'base'
require 'byebug'

module Material
  class RebarHook < Base
    MAX_FY = 550
    STANDARD_E_MODULE = 200_000
    MIN180_HOOK_LENGTH = 60
    MIN_STRIP_HOOK_LENGTH = 75

    attr_reader :angle, :length

    def initialize(f_limit:, e_module:, diameter:)
      @diameter = diameter
      @length = nil
      @angle = nil

      super(
        f_limit:,
        e_module: e_module || STANDARD_E_MODULE
      )
    end

    def use_angle_of90
      @angle = 90
      @length = 12 * @diameter
    end

    def use_angle_of180
      @angle = 180
      @length = [4 * @diameter, MIN180_HOOK_LENGTH].max
    end

    def use_angle_of(angle)
      @angle = angle
      @length = [6 * @diameter, MIN_STRIP_HOOK_LENGTH].max
    end
  end
end
