module StructuraidCore
  module Elements
    module Reinforcement
      # This class represents a longitudinal reinforcement. It groups all the layers that compose it on an object's face
      class StraightLongitudinal
        attr_reader :layers

        def initialize(distribution_direction:, above_middle: false)
          @above_middle = above_middle
          @layers = []
          @distribution_direction = distribution_direction
        end

        def add_layer(start_location:, end_location:, amount_of_rebars:, rebar:)
          new_layer = Elements::Reinforcement::StraightLongitudinalLayer.new(
            start_location:,
            end_location:,
            amount_of_rebars:,
            rebar:,
            distribution_direction: @distribution_direction
          )

          new_layer.reposition(above_middle: @above_middle)
          layers << new_layer

          new_layer
        end

        def empty?
          layers.empty?
        end

        def max_diameter
          layers.map(&:diameter).max
        end

        def amount_of_rebars
          layers.map(&:amount_of_rebars).reduce(:+)
        end

        def centroid_height
          return inertia / area unless layers.empty?

          raise Errors::Reinforcement::EmptyLayers, "can't complete centroid height calculation"
        end

        def area
          layers.map(&:area).reduce(:+)
        end

        def inertia
          layers.map(&:inertia).reduce(:+)
        end

        # Returns the maximum spacing between the rebars of the reinforcement layers
        def max_spacing
          layers.map(&:spacing).max
        end
      end
    end
  end
end
