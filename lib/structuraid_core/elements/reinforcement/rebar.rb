module StructuraidCore
  module Elements
    module Reinforcement
      # This class represents a reinforcement bar
      class Rebar
        include Utils::RebarData

        attr_reader :start_hook, :end_hook, :diameter, :number, :material

        def initialize(number:, material:)
          @start_hook = nil
          @end_hook = nil
          @number = number
          @material = material
          @diameter = find_standard_diameter(rebar_number: number)
        end

        def area
          rebar_area = Math::PI * (diameter**2) / 4
          rebar_area.to_f
        end

        def perimeter
          rebar_perimeter = Math::PI * diameter
          rebar_perimeter.to_f
        end

        def add_start_hook(hook)
          @start_hook = hook
        end

        def add_end_hook(hook)
          @end_hook = hook
        end

        def delete_start_hook
          @start_hook = nil
        end

        def delete_end_hook
          @end_hook = nil
        end
      end
    end
  end
end
