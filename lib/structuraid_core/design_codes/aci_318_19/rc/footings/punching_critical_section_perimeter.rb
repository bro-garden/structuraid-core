module StructuraidCore
  module DesignCodes
    module ACI31819
      module RC
        module Footings
          class PunchingCriticalSectionPerimeter
            include DesignCodes::Utils::CodeRequirement
            use_schema DesignCodes::Schemas::RC::Footings::PunchingCriticalSectionPerimeterSchema

            def call
              add_column_to_local_coordinates_system
              add_perimeter_vertices_to_local_coordinates_system
              edges_indexes = build_edges_indexes
              select_edges_indexes_into_the_footing(edges_indexes)
              update_edges_indexes_vertices(edges_indexes)
              compute_perimeter(edges_indexes)
            end

            private

            def update_edges_indexes_vertices(edges_indexes)
              edges_indexes.each do |edge|
                update_location_to_limit(relative_location_at_index(edge[:from]))
                update_location_to_limit(relative_location_at_index(edge[:to]))
              end
            end

            def select_edges_indexes_into_the_footing(edges_indexes)
              edges_indexes.select! do |edge|
                from_location_into_footing = into_footing?(
                  relative_location_at_index(edge[:from])
                )
                to_location_into_footing = into_footing?(
                  relative_location_at_index(edge[:to])
                )
                from_location_into_footing || to_location_into_footing
              end
            end

            def build_edges_indexes
              [{ from: 1, to: 2 }, { from: 2, to: 3 },
               { from: 3, to: 4 }, { from: 4, to: 1 }]
            end

            def add_perimeter_vertices_to_local_coordinates_system
              perimeter_vertices_relative_to_column_location.each do |perimeter_vertex|
                add_relative_location_from_a_vector(
                  perimeter_vertex + column_relative_location_vector
                )
              end
            end

            def add_column_to_local_coordinates_system
              add_relative_location_from_a_vector(
                column_absolute_location.to_vector - local_coordinates_system.anchor_location.to_vector
              )
            end

            def update_location_to_limit(location)
              location.value_1 = udate_to_constrain(location.value_1, 0.5 * footing.length_1)
              location.value_2 = udate_to_constrain(location.value_2, 0.5 * footing.length_2)
            end

            def udate_to_constrain(initial_value, constrain_value)
              return constrain_value if initial_value > constrain_value
              return -constrain_value if initial_value < -constrain_value

              initial_value
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
                perimeter_vertices_relative_to_column_location_with(way_1: 1, way_2: 1),
                perimeter_vertices_relative_to_column_location_with(way_1: -1, way_2: 1),
                perimeter_vertices_relative_to_column_location_with(way_1: -1, way_2: -1),
                perimeter_vertices_relative_to_column_location_with(way_1: 1, way_2: -1)
              ]
            end

            def perimeter_vertices_relative_to_column_location_with(way_1:, way_2:)
              Vector[
                way_1 * 0.5 * (column_section_length_1 + footing.effective_height),
                way_2 * 0.5 * (column_section_length_2 + footing.effective_height),
                0.0
              ]
            end

            def add_relative_location_from_a_vector(vector)
              relative_location = Engineering::Locations::Relative.from_vector(vector)
              local_coordinates_system.add_location(relative_location)
            end

            def relative_location_at_index(index)
              local_coordinates_system.relative_locations[index]
            end

            def column_relative_location_vector
              local_coordinates_system.first_location_vector
            end

            def local_coordinates_system
              footing.coordinates_system
            end

            def compute_perimeter(edges_indexes)
              edges_indexes.inject(0.0) do |perimeter, edge|
                vector_from = relative_location_at_index(edge[:from]).to_vector
                vector_to = relative_location_at_index(edge[:to]).to_vector
                perimeter + (vector_to - vector_from).magnitude
              end
            end
          end
        end
      end
    end
  end
end
