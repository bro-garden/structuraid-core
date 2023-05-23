require 'matrix'

module StructuraidCore
  module Engineering
    module Locations
      # This class represents a coordinates system located in space. It has an anchor absolute location and a collection of relative locations
      class CoordinatesSystem
        attr_reader :relative_locations, :axis_1, :anchor_location

        def initialize(anchor_location:)
          @anchor_location = anchor_location
          @relative_locations = Collection.new
          @axis_1 = Vector[1.0, 0.0, 0.0]
          @axis_3 = Vector[0.0, 0.0, 1.0]
        end

        def align_axis_1_with(vector:)
          relative_locations.each { |relative_location| rotate_axes(relative_location, theta(vector)) }
          @axis_1 = vector.normalize
        end

        def add_location(relative_location)
          relative_locations.add(relative_location)
        end

        def add_location_from_vector(vector, label:)
          relative_location = Relative.from_vector(vector, label:)
          add_location(relative_location)
        end

        def find_or_add_location_from_vector(vector, label:)
          relative_location = Relative.from_vector(vector, label:)

          relative_locations.find_or_add_by_label(relative_location)
        end

        def axis_2
          axis_3.cross_product axis_1
        end

        def find_location(label)
          relative_locations.find_by_label(label)
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
