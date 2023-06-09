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
            # @param support_type [Symbol or String] The support type: :over_soil or :over_piles
            def call
              return unless footing.reinforcement_ratio(direction: analysis_direction, above_middle: true).zero?

              add_reinforcement
            rescue Errors::Designers::DesignStepError => e
              context.fail!(message: e.message)
            end

            private

            def add_reinforcement
              return add_reinforcement_to_footing unless optimized_rebar.result_code == critical_result_code

              raise Errors::Designers::DesignStepError.new(optimized_rebar.result_code, "rebar couldm't be found")
            end

            def distribution_length
              return distribution_length_length_1 if analysis_direction == :length_1
              return distribution_length_length_2 if analysis_direction == :length_2
            end

            def distribution_length_length_1
              start_location = footing.coordinates_system.find_location(
                'reinforcement_layer_start_location_length_1_bottom'
              ).to_vector
              end_location = footing.coordinates_system.find_location(
                'reinforcement_layer_end_location_length_1_bottom'
              ).to_vector

              (end_location - start_location)[0]
            end

            def distribution_length_length_2
              start_location = footing.coordinates_system.find_location(
                'reinforcement_layer_start_location_length_2_bottom'
              ).to_vector
              end_location = footing.coordinates_system.find_location(
                'reinforcement_layer_end_location_length_2_bottom'
              ).to_vector

              (end_location - start_location)[1]
            end

            def reinforcement_baseline
              secondary_direction_reinforcement = footing.reinforcement(
                direction: secondary_analysis_direction,
                above_middle: false
              )
              return footing.cover_bottom if secondary_direction_reinforcement.empty?

              footing.cover_bottom + secondary_direction_reinforcement.max_diameter
            end

            def required_reinforcement_area
              required_reinforcement_ratio *
                footing.width(section_direction: analysis_direction) *
                (footing.height - reinforcement_baseline)
            end

            def add_reinforcement_to_footing
              footing.reinforcement(direction: analysis_direction, above_middle: false).add_layer(
                start_location: context.reinforcement_layer_start_location,
                end_location: context.reinforcement_layer_end_location,
                amount_of_rebars: optimized_rebar.amount_of_rebars,
                rebar: optimized_rebar.rebar
              )
            end

            def optimized_rebar
              @optimized_rebar ||= StructuraidCore::Optimization::RebarWithConstantLength
                                   .new(
                                     required_reinforcement_area,
                                     design_code::Rc::Footings::MaximumRebarSpacing.call(
                                       support_type:,
                                       footing_height: footing.height,
                                       for_min_rebar: analysis_results.is_minimum_ratio,
                                       yield_stress: steel.yield_stress,
                                       reinforcement_cover: footing.cover_bottom
                                     ),
                                     distribution_length,
                                     100
                                   )
                                   .run
            end

            def steel
              @steel ||= context.steel
            end

            def support_type
              @support_type ||= context.support_type
            end

            def required_reinforcement_ratio
              @required_reinforcement_ratio ||= analysis_results.computed_ratio
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

            def critical_result_code
              StructuraidCore::Optimization::RebarWithConstantLength::CRITICAL_RESULT_CODE
            end
          end
        end
      end
    end
  end
end
