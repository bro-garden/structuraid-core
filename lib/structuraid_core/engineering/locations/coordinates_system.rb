require 'matrix'

module StructuraidCore
  module Engineering
    module Locations
      class CoordinatesSystem < Base
        attr_reader :relative_locations, :axis_1

        def initialize(anchor_location:, relative_locations: [])
          @anchor_location = anchor_location
          @relative_locations = relative_locations
          @axis_1 = Vector[1.0, 0.0, 0.0]
          @axis_3 = Vector[0.0, 0.0, 1.0]
        end

        def align_axis_1_with(vector:)
          relative_locations.each { |relative_location| rotate_axes(relative_location, theta(vector)) }
          @axis_1 = vector.normalize
        end

        def add_location(relative_location)
          relative_locations << relative_location
        end

        def axis_2
          axis_3.cross_product axis_1
        end

        def clear_locations
          @relative_locations = []
        end

        def first_location_vector
          relative_locations.first.to_vector
        end

        def last_location_vector
          relative_locations.last.to_vector
        end

        def append_location(location)
          relative_locations.append(location)
        end

        def prepend_location(location)
          relative_locations.prepend(location)
        end

        private

        attr_reader :axis_3

        def theta(vector)
          unitary_vector = vector.normalize
          return Math.acos(axis_1.inner_product(unitary_vector)) if axis_1.cross_product(unitary_vector)[2].zero?

          Math.asin(axis_1.cross_product(unitary_vector)[2])
        end

        def rotate_axes(relative_location, theta)
          transformed = rotation_matrix(theta) * relative_location.to_matrix
          transformed_vector = Vector[
            transformed[0, 0],
            transformed[1, 0],
            transformed[2, 0]
          ]
          relative_location.update_from_vector(transformed_vector)
        end

        def rotation_matrix(theta)
          Matrix[
            [Math.cos(theta), Math.sin(theta), 0.0],
            [-Math.sin(theta), Math.cos(theta), 0.0],
            [0.0, 0.0, 1.0]
          ]
        end
      end
    end
  end
end
