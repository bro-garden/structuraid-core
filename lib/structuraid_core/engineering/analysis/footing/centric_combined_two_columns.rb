module StructuraidCore
  module Engineering
    module Analysis
      module Footing
        # This class contains the analysiss equations of a centric combined footing with two columns
        class CentricCombinedTwoColumns
          include Utils::BasicGeometry
          include Utils::Centroid
          include Utils::OneWayShear
          include Utils::OneWayMoment

          def initialize(footing:, loads_from_columns:, section_direction:)
            if ORTHOGONALITIES.none?(section_direction)
              raise Errors::Engineering::Analysis::SectionDirectionError.new(section_direction, ORTHOGONALITIES)
            end

            @footing = footing
            @loads_from_columns = loads_from_columns
            @section_direction = section_direction
          end

          def build_geometry
            add_loads_to_coordinates_system
            align_coordinates_system_with_loads
            add_vertices_location_to_coordinates_system
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

          def align_coordinates_system_with_loads
            last_load_location_label = "load_#{loads_from_columns.last.label}"
            aligner_vector = coordinates_system.find_location(last_load_location_label).to_vector
            coordinates_system.align_axis_1_with(vector: aligner_vector)
          end

          def add_loads_to_coordinates_system
            centroid = absolute_centroid

            loads_from_columns.each do |load_from_column|
              coordinates_system.find_or_add_location_from_vector(
                load_from_column.location.to_vector - centroid.to_vector,
                label: "load_#{load_from_column.label}"
              )
            end
          end

          def add_vertices_location_to_coordinates_system
            footing.add_vertices_location
          end

          def length_border_to_first_column
            load_location_label = "load_#{loads_from_columns.first.label}"
            load_location_vector = coordinates_system.find_location(load_location_label).to_vector
            vertex_location_vector = coordinates_system.find_location('vertex_top_left').to_vector

            (load_location_vector - vertex_location_vector)[0].abs
          end

          def length_first_column_to_second_column
            first_load_location_label = "load_#{loads_from_columns.first.label}"
            first_load_location_vector = coordinates_system.find_location(first_load_location_label).to_vector

            last_load_location_label = "load_#{loads_from_columns.last.label}"
            last_load_location_vector = coordinates_system.find_location(last_load_location_label).to_vector

            (last_load_location_vector - first_load_location_vector)[0].abs
          end

          def length_second_column_to_border
            load_location_label = "load_#{loads_from_columns.last.label}"
            load_location_vector = coordinates_system.find_location(load_location_label).to_vector
            vertex_location_vector = coordinates_system.find_location('vertex_top_right').to_vector

            (vertex_location_vector - load_location_vector)[0].abs
          end
        end
      end
    end
  end
end
