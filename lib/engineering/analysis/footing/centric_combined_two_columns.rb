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

        Column_load = Struct.new(:load_data, :relative_location) do
          def value
            load_data.value
          end

          def absolute_location
            load_data.location
          end
        end

        def initialize(footing:, loads_from_columns:, section_direction:)
          if ORTHOGONALITIES.none?(section_direction)
            raise Engineering::Analysis::SectionDirectionError.new(section_direction, ORTHOGONALITIES)
          end

          @footing = footing
          @loads_from_columns = loads_from_columns.map { |load| Column_load.new(load, nil) }
          @section_direction = section_direction
        end

        def solicitation_load
          solicitation * orthogonal_length
        end

        def shear
          geometry
        end

        def absolute_centroid
          moment_xx, moment_yy, total_load = *moment_and_load_totals

          Engineering::Locations::Absolute.new(
            value_x: moment_xx / total_load,
            value_y: moment_yy / total_load,
            value_z: value_z_mean
          )
        end

        def geometry
          relativize_loads_from_columns
          align_axis_1_whit_columns

          {
            edge_1: edge_relative_location(relative_location: loads_from_columns.first.relative_location),
            loads_from_columns:,
            edge_2: edge_relative_location(relative_location: loads_from_columns.last.relative_location)
          }
        end

        private

        attr_reader :footing, :section_direction, :loads_from_columns

        def edge_relative_location(relative_location:)
          vector_to_edge = Engineering::Vector.with_value(
            value: section_length / 2,
            direction: relative_location.to_vector.direction
          )

          Engineering::Locations::Relative.new(
            value_1: vector_to_edge.value_i,
            value_2: vector_to_edge.value_j,
            value_3: vector_to_edge.value_k,
            origin: relative_location.origin,
            angle: relative_location.angle
          )
        end

        def align_axis_1_whit_columns
          relativize_loads_from_columns
          aligner_vector = loads_from_columns.last.relative_location.to_vector

          loads_from_columns.each do |load_from_column|
            load_from_column.relative_location.align_axis_1_with(vector: aligner_vector)
          end

          loads_from_columns
        end

        def relativize_loads_from_columns
          loads_from_columns.each do |load_from_column|
            load_from_column.relative_location = Engineering::Locations::Relative.from_location_to_location(
              from: absolute_centroid,
              to: load_from_column.absolute_location
            )
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
            moment_xx += load_from_column.value * load_from_column.absolute_location.value_x
            moment_yy += load_from_column.value * load_from_column.absolute_location.value_y
            total_load += load_from_column.value
          end

          [moment_xx, moment_yy, total_load]
        end

        def value_z_mean
          loads_from_columns.sum { |load_from_column|
            load_from_column.absolute_location.value_z
          } / loads_from_columns.size
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
