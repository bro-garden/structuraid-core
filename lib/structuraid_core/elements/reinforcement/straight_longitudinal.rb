module StructuraidCore
  module Elements
    module Reinforcement
      class StraightLongitudinal < Base
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
          @layers << new_layer

          new_layer
        end

        def centroid_height
          return inertia / area unless @layers.empty?

          raise Elements::Reinforcement::EmptyLayers, "can't complete centroid height calculation"
        end

        def area
          @layers.map(&:area).reduce(:+)
        end

        def inertia
          @layers.map(&:inertia).reduce(:+)
        end
      end
    end
  end
end
