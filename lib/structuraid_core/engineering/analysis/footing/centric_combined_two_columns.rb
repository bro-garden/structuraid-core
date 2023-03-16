module StructuraidCore
  module Engineering
    module Analysis
      module Footing
        class CentricCombinedTwoColumns < Base
          include Utils::Data
          include Utils::Centroid
          include Utils::ShearMoment

          def initialize(footing:, loads_from_columns:, section_direction:)
            if ORTHOGONALITIES.none?(section_direction)
              raise Engineering::Analysis::SectionDirectionError.new(section_direction, ORTHOGONALITIES)
            end

            @footing = footing
            @loads_from_columns = loads_from_columns
            @section_direction = section_direction
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

          def reaction_1
            -(solicitation * @footing.horizontal_area + reaction_2)
          end

          def reaction_2
            (solicitation_load / 2 / long_stretch_2) * (long_stretch_1**2 - (long_stretch_2 + long_stretch_3)**2)
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
              Engineering::Locations::Relative.new(value_1: -section_length / 2, value_2: 0, value_3: 0),
              coordinates_system.relative_locations.last,
              coordinates_system.relative_locations.first,
              Engineering::Locations::Relative.new(value_1: section_length / 2, value_2: 0, value_3: 0)
            ]
          end

          def long_stretch_1
            (coordinates_system.relative_locations[1].to_vector - coordinates_system.relative_locations[0].to_vector)
              .magnitude
          end

          def long_stretch_2
            (coordinates_system.relative_locations[2].to_vector - coordinates_system.relative_locations[1].to_vector)
              .magnitude
          end

          def long_stretch_3
            (coordinates_system.relative_locations[3].to_vector - coordinates_system.relative_locations[2].to_vector)
              .magnitude
          end
        end
      end
    end
  end
end
