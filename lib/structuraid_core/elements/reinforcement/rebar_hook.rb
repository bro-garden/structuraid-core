module StructuraidCore
  module Elements
    module Reinforcement
      # This class represents a reinforcement bar hook
      class RebarHook
        include Utils::RebarData

        attr_reader :angle

        def initialize(number:, material:)
          @angle = nil
          @number = number
          @material = material
          @diameter = find_standard_diameter(rebar_number: number)
        end
      end
    end
  end
end
