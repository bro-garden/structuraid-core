require 'interactor'
require 'matrix'

module StructuraidCore
  module Designers
    module Footings
      module Steps
        module CentricIsolated
          # Runs the structural bending analysis and design for a centric isolated footing, generating the required reinforcement ratio and checking that the provided one is enough
          class SetInitialLongitudinalReinforcement
            include Interactor

            POSSIBLE_SECCTIONS = %i[length_1 length_2].freeze

            # @param footing [StructuraidCore::Elements::Footing] The footing to be designed
            # @param load_scenario [StructuraidCore::Loads::Scenarios::Footings::CentricIsolated] The load scenario to be considered
            # @param analysis_direction [Symbol] The direction for which the analysis has to be run. Should be either :length_1 or :length2
            # @param design_code [StructuraidCore::DesignCodes] The design code to be used
            # @param steel [StructuraidCore::Materials::Steel] The rebar's material
            def call
              return unless footing.reinforcement_ratio(direction: analysis_direction, above_middle: true).zero?

              reinforcement_baseline
              add_reinforcement if footing.reinforcement_ratio(direction: analysis_direction, above_middle: true).zero?
            rescue Errors::DesignCodes::RequirementNotFulfilledError => e
              context.fail!(message: e.message)
            end

            private

            def add_reinforcement
              rebar = StructuraidCore::Elements::Reinforcement::Rebar.new(
                number: 3,
                material: StructuraidCore::Materials::Steel.new(yield_stress: 420)
              )

              footing.reinforcement(direction: analysis_direction, above_middle: false).add_layer(
                start_location: reinforcement_layer_start_location,
                end_location: reinforcement_layer_end_location,
                amount_of_rebars: required_amaunt_of_rebar(rebar),
                rebar:
              )
            end

            def reinforcement_layer_start_location
              return add_reinforcement_layer_start_location_length_1_bottom if analysis_direction == :length_1

              add_reinforcement_layer_start_location_length_2_bottom
            end

            def reinforcement_layer_end_location
              return add_reinforcement_layer_end_location_length_1_bottom if analysis_direction == :length_1

              add_reinforcement_layer_end_location_length_2_bottom
            end

            def reinforcement_baseline
              secondary_direction_reinforcement = footing.reinforcement(
                direction: secondary_analysis_direction,
                above_middle: false
              )
              return footing.cover_bottom if secondary_direction_reinforcement.empty?

              footing.cover_bottom + secondary_direction_reinforcement.max_diameter
            end

            def required_amaunt_of_rebar(rebar)
              calculated = required_reinforcement_area / rebar.area
              integer_amount = calculated.round
              return integer_amount unless integer_amount < calculated

              integer_amount + 1
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

            def required_reinforcement_area
              required_reinforcement_ratio *
                footing.width(section_direction: analysis_direction) *
                (footing.height - reinforcement_baseline)
            end

            def required_reinforcement_ratio
              @required_reinforcement_ratio ||= analysis_results[:required_reinforcement_ratio]
            end

            def footing
              @footing ||= context.footing
            end

            def analysis_results
              @analysis_results ||= context.analysis_results
            end

            def analysis_direction
              @analysis_direction ||= context.analysis_direction
            end

            def secondary_analysis_direction
              POSSIBLE_SECCTIONS.reject { |section| section == analysis_direction }.first
            end

            def design_code
              @design_code ||= context.design_code
            end
          end
        end
      end
    end
  end
end
