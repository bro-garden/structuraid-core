module StructuraidCore
  module Engineering
    module Analysis
      module Footing
        class CentricCombinedTwoColumns < Base
          ORTHOGONALITIES = %i[length_1 length_2].freeze

          include Utils::TwoColumnsShearMomentum

          def initialize(footing:, loads_from_columns:, section_direction:)
            if ORTHOGONALITIES.none?(section_direction)
              raise Engineering::Analysis::SectionDirectionError.new(section_direction, ORTHOGONALITIES)
            end

            @footing = footing
            @loads_from_columns = loads_from_columns
            @section_direction = section_direction
          end

          def solicitation_load
            solicitation * orthogonal_length
          end

          def absolute_centroid
            moment_xx, moment_yy, total_load = *moment_and_load_totals

            Engineering::Locations::Absolute.new(
              value_x: moment_xx / total_load,
              value_y: moment_yy / total_load,
              value_z: loads_from_columns.first.location.value_z
            )
          end

          def build_geometry(coordinates_system)
            @coordinates_system = coordinates_system

            coordinates_system.relative_locations.clear
            relativize_loads

            aligner_vector = coordinates_system.relative_locations.first.to_vector
            coordinates_system.align_axis_1_with(vector: aligner_vector)
            locations_with_edges = include_edges_location

            coordinates_system.relative_locations.clear
            locations_with_edges.each { |location| coordinates_system.add_location(location) }
          end

          def reaction_2
            (solicitation_load / 2 / long_2) * (long_1**2 - (long_2 + long_3)**2)
          end

          def reaction_1
            -(solicitation * @footing.horizontal_area + reaction_2)
          end

          private

          attr_reader :footing, :section_direction, :loads_from_columns, :coordinates_system

          def relativize_loads
            centroid = absolute_centroid

            loads_from_columns.map do |load_from_column|
              coordinates_system.add_location(
                Engineering::Locations::Relative.from_matrix(
                  load_from_column.location.to_matrix - centroid.to_matrix
                )
              )
            end
          end

          def include_edges_location
            [
              Engineering::Locations::Relative.new(value_1: section_length / 2, value_2: 0, value_3: 0),
              coordinates_system.relative_locations.first,
              coordinates_system.relative_locations.last,
              Engineering::Locations::Relative.new(value_1: -section_length / 2, value_2: 0, value_3: 0)
            ]
          end

          def long_1
            (coordinates_system.relative_locations[1].to_vector - coordinates_system.relative_locations[0].to_vector)
              .magnitude
          end

          def long_2
            (coordinates_system.relative_locations[2].to_vector - coordinates_system.relative_locations[1].to_vector)
              .magnitude
          end

          def long_3
            (coordinates_system.relative_locations[3].to_vector - coordinates_system.relative_locations[2].to_vector)
              .magnitude
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
end
