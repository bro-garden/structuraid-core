require 'byebug'

module StructuraidCore
  module Engineering
    module Analysis
      module Footing
        class CentricCombinedTwoColumns < Base
          include Utils::BasicGeometry
          include Utils::Centroid
          include Utils::OneWayShear
          include Utils::OneWayMoment

          def initialize(footing:, loads_from_columns:, section_direction:)
            if ORTHOGONALITIES.none?(section_direction)
              raise Engineering::Analysis::SectionDirectionError.new(section_direction, ORTHOGONALITIES)
            end

            @footing = footing
            @loads_from_columns = loads_from_columns
            @section_direction = section_direction
          end

          def build_geometry
            coordinates_system.clear_locations
            relativize_loads

            aligner_vector = coordinates_system.last_location_vector
            coordinates_system.align_axis_1_with(vector: aligner_vector)

            include_edges_locations_to_coordinates_system
          end

          def reaction_at_first_column
            -(solicitation * @footing.horizontal_area + reaction_at_second_column)
          end

          def reaction_at_second_column
            local_length_1 = length_border_to_first_column
            local_length_2 = length_first_column_to_second_column
            local_length_3 = length_second_column_to_border

            (solicitation_load / 2 / local_length_2) * (local_length_1**2 - (local_length_2 + local_length_3)**2)
          end

          private

          attr_reader :footing, :section_direction, :loads_from_columns

          def coordinates_system
            footing.coordinates_system
          end

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

          def include_edges_locations_to_coordinates_system
            coordinates_system.prepend_location(
              Engineering::Locations::Relative.new(value_1: -section_length / 2, value_2: 0, value_3: 0)
            )
            coordinates_system.append_location(
              Engineering::Locations::Relative.new(value_1: section_length / 2, value_2: 0, value_3: 0)
            )

            coordinates_system
          end

          def length_border_to_first_column
            (coordinates_system.relative_locations[1].to_vector - coordinates_system.relative_locations[0].to_vector)
              .magnitude
          end

          def length_first_column_to_second_column
            (coordinates_system.relative_locations[2].to_vector - coordinates_system.relative_locations[1].to_vector)
              .magnitude
          end

          def length_second_column_to_border
            (coordinates_system.relative_locations[3].to_vector - coordinates_system.relative_locations[2].to_vector)
              .magnitude
          end
        end
      end
    end
  end
end
