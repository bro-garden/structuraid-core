require 'byebug'

module StructuraidCore
  module DesignCodes
    module ACI31819
      module RC
        module Footings
          class PunchingCriticalSectionPerimeter
            include DesignCodes::Utils::CodeRequirement
            use_schema DesignCodes::Schemas::RC::Footings::PunchingCriticalSectionPerimeterSchema

            EDGES_INDEXES = {
              top: { from: :top_right, to: :top_left },
              left: { from: :top_left, to: :bottom_left },
              bottom: { from: :bottom_left, to: :bottom_right },
              right: { from: :bottom_right, to: :top_right }
            }.freeze

            def call
              column_location = footing.find_or_add_column_location(column_absolute_location, column_label)
              perimeter_vertices = build_initial_perimeter(column_location)

              edges_indexes = EDGES_INDEXES
              edges_indexes = select_edges_indexes_into_the_footing(edges_indexes, perimeter_vertices)
              edges_indexes = update_edges_indexes_vertices(edges_indexes, perimeter_vertices)
              compute_perimeter(edges_indexes, perimeter_vertices)
            end

            private

            def update_edges_indexes_vertices(edges_indexes, perimeter_vertices)
              edges_indexes.each do |_edge_name, edge|
                update_location_to_limit(perimeter_vertices[edge[:from]])
                update_location_to_limit(perimeter_vertices[edge[:to]])
              end
            end

            def select_edges_indexes_into_the_footing(edges_indexes, perimeter_vertices)
              edges_indexes.select do |_edge_name, edge|
                start_vertex_inside_footing = footing.inside_me?(perimeter_vertices[edge[:from]])
                end_vertex_inside_footing = footing.inside_me?(perimeter_vertices[edge[:to]])

                start_vertex_inside_footing || end_vertex_inside_footing
              end
            end

            def build_initial_perimeter(column_location)
              perimeter_vertices_relative_to_column_location.map do |label, perimeter_vertex|
                location = local_coordinates_system.find_or_add_location_from_vector(
                  perimeter_vertex + column_location.to_vector,
                  label: "column_#{column_label}_punching_#{label}"
                )
                [label, location]
              end.to_h
            end

            def update_location_to_limit(location)
              location.value_1 = update_to_constraint(location.value_1, 0.5 * footing.length_1)
              location.value_2 = update_to_constraint(location.value_2, 0.5 * footing.length_2)
            end

            def update_to_constraint(initial_value, constraint_value)
              if initial_value > constraint_value
                constraint_value
              elsif initial_value < -constraint_value
                -constraint_value
              else
                initial_value
              end
            end

            def perimeter_vertices_relative_to_column_location
              {
                top_right: perimeter_vertices_relative_to_column_location_with(way_1: 1, way_2: 1),
                top_left: perimeter_vertices_relative_to_column_location_with(way_1: -1, way_2: 1),
                bottom_left: perimeter_vertices_relative_to_column_location_with(way_1: -1, way_2: -1),
                bottom_right: perimeter_vertices_relative_to_column_location_with(way_1: 1, way_2: -1)
              }
            end

            def perimeter_vertices_relative_to_column_location_with(way_1:, way_2:)
              Vector[
                way_1 * 0.5 * (column_section_length_1 + footing.effective_height),
                way_2 * 0.5 * (column_section_length_2 + footing.effective_height),
                0.0
              ]
            end

            def local_coordinates_system
              footing.coordinates_system
            end

            def compute_perimeter(edges_indexes, perimeter_vertices)
              edges_indexes.map do |_edge_name, edge|
                vector_from = perimeter_vertices[edge[:from]].to_vector
                vector_to = perimeter_vertices[edge[:to]].to_vector
                (vector_to - vector_from).magnitude
              end.sum
            end
          end
        end
      end
    end
  end
end
