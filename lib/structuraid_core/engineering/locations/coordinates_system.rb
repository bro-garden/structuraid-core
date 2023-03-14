require 'matrix'

module StructuraidCore
  module Engineering
    module Locations
      class CoordinatesSystem < Base
        attr_reader :relative_locations

        def initialize(anchor_location:)
          @anchor_location = anchor_location
          @theta = 0.0
          @relative_locations = []
        end

        def align_axis_1_with(vector:)
          align_axis_1_with_global_x unless theta.zero?

          @theta = Math.atan2(vector.value_j, vector.value_i)
          relative_locations.each { |relative_location| rotate_axes(relative_location:) }
        end

        def align_axis_1_with_global_x
          theta if theta.zero?

          relative_locations.each { |relative_location| rotate_axes(relative_location:, to_global: true) }
          @theta = 0.0
        end

        def add(relative_location:)
          @relative_locations << relative_location
        end

        private

        attr_reader :theta

        def rotate_axes(relative_location:, to_global: false)
          transformer = to_global ? transformer_matrix_relative_to_global : transformer_matrix_global_to_relative
          transformed = transformer * relative_location.to_matrix
          relative_location.update_from_matrix(transformed)
        end

        def transformer_matrix_global_to_relative
          Matrix[
            [Math.cos(theta), Math.sin(theta), 0.0],
            [-Math.sin(theta), Math.cos(theta), 0.0],
            [0.0, 0.0, 1.0]
          ]
        end

        def transformer_matrix_relative_to_global
          Matrix[
            [Math.cos(theta), -Math.sin(theta), 0.0],
            [Math.sin(theta), Math.cos(theta), 0.0],
            [0.0, 0.0, 1.0]
          ]
        end
      end
    end
  end
end
