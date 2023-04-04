module StructuraidCore
  module DesignCodes
    module NSR10
      module RC
        module Footings
          class PunchingCriticalSectionPerimeter
            CODE_REFERENCE = 'NSR-10 C.11.11'.freeze

            include DesignCodes::Utils::CodeRequirement
            use_schema DesignCodes::Schemas::RC::Footings::PunchingCriticalSectionPerimeterSchema

            # NSR-10 C.11.11

            def call
              add_column_to_local_coordinates_system
              add_perimeter_vertices_to_local_coordinates_system
              edges = []
              build_edges(edges)
              select_edges_into_the_footing(edges)
            end

            private

            def select_edges_into_the_footing(edges)
              edges.select! do |edge|
                from_location_into_footing = into_footing?(
                  local_coordinates_system.relative_locations[edge[:from]]
                )
                to_location_into_footing = into_footing?(
                  local_coordinates_system.relative_locations[edge[:to]]
                )
                from_location_into_footing || to_location_into_footing
              end
            end

            def build_edges(edges)
              edges << { from: 1, to: 2 }
              edges << { from: 2, to: 3 }
              edges << { from: 3, to: 4 }
              edges << { from: 4, to: 1 }
            end

            def add_perimeter_vertices_to_local_coordinates_system
              perimeter_vertices_relative_to_column_location.each do |perimeter_vertex_relative_to_column_location|
                add_relative_location_from_a_vector(
                  perimeter_vertex_relative_to_column_location + column_relative_location_vector
                )
              end
            end

            def add_column_to_local_coordinates_system
              add_relative_location_from_a_vector(
                column_absolute_location.to_vector - local_coordinates_system.anchor_location.to_vector
              )
            end

            def into_footing?(location)
              vertical_check(location) && horizontal_check(location)
            end

            def vertical_check(location)
              location.value_2 >= -0.5 * footing.length_2 && location.value_2 <= 0.5 * footing.length_2
            end

            def horizontal_check(location)
              location.value_1 >= -0.5 * footing.length_1 && location.value_1 <= 0.5 * footing.length_1
            end

            def perimeter_vertices_relative_to_column_location
              [
                perimeter_vertices_relative_to_column_location_1,
                perimeter_vertices_relative_to_column_location_2,
                perimeter_vertices_relative_to_column_location_3,
                perimeter_vertices_relative_to_column_location_4
              ]
            end

            def perimeter_vertices_relative_to_column_location_1
              Vector[
                0.5 * (column_section_length_1 + footing.effective_height),
                0.5 * (column_section_length_2 + footing.effective_height),
                0.0
              ]
            end

            def perimeter_vertices_relative_to_column_location_2
              Vector[
                - 0.5 * (column_section_length_1 + footing.effective_height),
                0.5 * (column_section_length_2 + footing.effective_height),
                0.0
              ]
            end

            def perimeter_vertices_relative_to_column_location_3
              Vector[
                - 0.5 * (column_section_length_1 + footing.effective_height),
                - 0.5 * (column_section_length_2 + footing.effective_height),
                0.0
              ]
            end

            def perimeter_vertices_relative_to_column_location_4
              Vector[
                0.5 * (column_section_length_1 + footing.effective_height),
                - 0.5 * (column_section_length_2 + footing.effective_height),
                0.0
              ]
            end

            def add_relative_location_from_a_vector(vector)
              relative_location = Engineering::Locations::Relative.new(
                value_1: 0,
                value_2: 0,
                value_3: 0
              )
              relative_location.update_from_vector(vector)
              local_coordinates_system.add_location(relative_location)
            end

            def column_relative_location_vector
              local_coordinates_system.first_location_vector
            end

            def local_coordinates_system
              footing.coordinates_system
            end
          end
        end
      end
    end
  end
end
