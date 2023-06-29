require 'interactor'
require 'matrix'

module StructuraidCore
  module Designers
    module Footings
      module Steps
        module CentricIsolated
          # Sets the reinforcement layers coordinates to the footing's coordinates system
          class SetReinforcementLayersCoordinatesToFooting
            include Interactor

            POSSIBLE_SECTIONS = %i[length_1 length_2].freeze

            # @param footing [StructuraidCore::Elements::Footing] The footing to be designed
            # @param analysis_direction [Symbol] The direction for which the analysis has to be run. Should be either :length_1 or :length2
            def call
              return unless footing.reinforcement_ratio(direction: analysis_direction, above_middle: true).nil?

              add_reinforcement_layer_start_location
              add_reinforcement_layer_end_location
            end

            private

            def add_reinforcement_layer_start_location
              return add_reinforcement_layer_start_location_length_1_bottom if analysis_direction == :length_1

              add_reinforcement_layer_start_location_length_2_bottom
            end

            def add_reinforcement_layer_end_location
              return add_reinforcement_layer_end_location_length_1_bottom if analysis_direction == :length_1

              add_reinforcement_layer_end_location_length_2_bottom
            end

            def reinforcement_baseline
              secondary_direction_reinforcement = footing.reinforcement(
                direction: secondary_analysis_direction,
                above_middle: false
              )
              return footing.cover_bottom unless secondary_direction_reinforcement

              footing.cover_bottom + secondary_direction_reinforcement.max_diameter
            end

            def add_reinforcement_layer_start_location_length_1_bottom
              footing.coordinates_system.find_or_add_location_from_vector(
                footing.coordinates_system.find_location(:vertex_bottom_left).to_vector + Vector[
                  footing.cover_lateral, footing.cover_lateral, reinforcement_baseline
                ],
                label: 'reinforcement_layer_start_location_length_1_bottom'
              )
            end

            def add_reinforcement_layer_end_location_length_1_bottom
              footing.coordinates_system.find_or_add_location_from_vector(
                footing.coordinates_system.find_location(:vertex_top_right).to_vector + Vector[
                  -footing.cover_lateral, -footing.cover_lateral, reinforcement_baseline
                ],
                label: 'reinforcement_layer_end_location_length_1_bottom'
              )
            end

            def add_reinforcement_layer_start_location_length_2_bottom
              footing.coordinates_system.find_or_add_location_from_vector(
                footing.coordinates_system.find_location(:vertex_top_left).to_vector + Vector[
                  footing.cover_lateral, -footing.cover_lateral, reinforcement_baseline
                ],
                label: 'reinforcement_layer_start_location_length_2_bottom'
              )
            end

            def add_reinforcement_layer_end_location_length_2_bottom
              footing.coordinates_system.find_or_add_location_from_vector(
                footing.coordinates_system.find_location(:vertex_bottom_right).to_vector + Vector[
                  -footing.cover_lateral, footing.cover_lateral, reinforcement_baseline
                ],
                label: 'reinforcement_layer_end_location_length_2_bottom'
              )
            end

            def footing
              @footing ||= context.footing
            end

            def analysis_direction
              @analysis_direction ||= context.analysis_direction
            end

            def secondary_analysis_direction
              POSSIBLE_SECTIONS.reject { |section| section == analysis_direction }.first
            end
          end
        end
      end
    end
  end
end
