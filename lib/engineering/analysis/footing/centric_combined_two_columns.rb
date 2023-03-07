require 'errors/engineering/analysis/section_direction_error'
require 'engineering/locations/absolute'
require 'engineering/locations/relative'
require 'engineering/vector'

# rubocop:disable Metrics/ClassLength
module Engineering
  module Analysis
    module Footing
      class CentricCombinedTwoColumns
        ORTHOGONALITIES = %i[length_1 length_2].freeze

        def initialize(footing:, loads_from_columns:, section_direction:)
          if ORTHOGONALITIES.none?(section_direction)
            raise Engineering::Analysis::SectionDirectionError.new(section_direction, ORTHOGONALITIES)
          end

          @footing = footing
          @loads_from_columns = loads_from_columns
          @section_direction = section_direction
          sort_point_loads_relative_to_centroid
        end

        def solicitation_load
          solicitation * orthogonal_length
        end

        def shear
          geometry
        end

        private

        attr_reader :footing, :section_direction, :loads_from_columns

        def geometry; end

        def absolute_centroid
          moment_xx, moment_yy, total_load = *moment_and_load_totals

          Engineering::Locations::Absolute.new(
            value_x: moment_xx / total_load,
            value_y: moment_yy / total_load,
            value_z: value_z_mean
          )
        end

        def vector_left_load_to_footing_edge
          Engineering::Vector.with_value(
            value: section_length * 0.5,
            direction: vector_centroid_to_left_load.direction
          )
        end

        def vector_right_load_to_footing_edge
          Engineering::Vector.with_value(
            value: section_length * 0.5,
            direction: vector_centroid_to_right_load.direction
          )
        end

        def vector_centroid_to_left_load
          Engineering::Vector.based_on_relative_location(
            location: Engineering::Locations::Relative.absolute_location_relative_to(
              location_to_relativize: loads_from_columns.first.location,
              reference_location: absolute_centroid
            )
          )
        end

        def vector_centroid_to_right_load
          Engineering::Vector.based_on_relative_location(
            location: Engineering::Locations::Relative.absolute_location_relative_to(
              location_to_relativize: loads_from_columns.last.location,
              reference_location: absolute_centroid
            )
          )
        end

        def sort_point_loads_relative_to_centroid
          loads_from_columns.sort! do |load_1, load_2|
            vector_centroid_to_load_1 = create_vector(from: absolute_centroid, to: load_1)
            vector_centroid_to_load_2 = create_vector(from: absolute_centroid, to: load_2)

            pair_of_locations = pair_to_sort(vector_centroid_to_load_1:, vector_centroid_to_load_2:)
            pair_of_locations[0] <=> pair_of_locations[1]
          end
        end

        def create_vector(from:, to:)
          Engineering::Vector.based_on_relative_location(
            location: Engineering::Locations::Relative.absolute_location_relative_to(
              location_to_relativize: to.location,
              reference_location: from
            )
          )
        end

        def pair_to_sort(vector_centroid_to_load_1:, vector_centroid_to_load_2:)
          if vector_centroid_to_load_1.direction[0] == vector_centroid_to_load_2.direction[0]
            [vector_centroid_to_load_1.direction[1], vector_centroid_to_load_2.direction[1]]
          else
            [vector_centroid_to_load_1.direction[0], vector_centroid_to_load_2.direction[0]]
          end
        end

        def section_length
          footing.public_send(section_direction)
        end

        def orthogonal_length
          footing.public_send(orthogonal_direction)
        end

        def moment_and_load_totals
          moment_xx = 0
          moment_yy = 0
          total_load = 0

          loads_from_columns.each do |load_from_column|
            moment_xx += load_from_column.value * load_from_column.location.value_x
            moment_yy += load_from_column.value * load_from_column.location.value_y
            total_load += load_from_column.value
          end

          [moment_xx, moment_yy, total_load]
        end

        def value_z_mean
          loads_from_columns.sum { |load_from_column| load_from_column.location.value_z } / loads_from_columns.size
        end

        def solicitation
          loads_from_columns.sum(&:value) / @footing.horizontal_area
        end

        def orthogonal_direction
          orthogonal = ORTHOGONALITIES - [@cut_direction]
          orthogonal.last
        end
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
