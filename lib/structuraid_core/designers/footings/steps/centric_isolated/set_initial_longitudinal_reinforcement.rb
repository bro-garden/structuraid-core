require 'interactor'
require 'matrix'

module StructuraidCore
  module Designers
    module Footings
      module Steps
        module CentricIsolated
          # Sets the reinforcement layers coordinates to the footing
          class SetInitialLongitudinalReinforcement
            include Interactor

            POSSIBLE_SECTIONS = %i[length_1 length_2].freeze

            # @param footing [StructuraidCore::Elements::Footing] The footing to be designed
            # @param design_code [StructuraidCore::DesignCodes] The design code to be used
            # @param steel [StructuraidCore::Materials::Steel] The rebar's material
            # @param support_type [Symbol or String] The support type: :over_soil or :over_piles
            # @param analysis_direction [Symbol] The direction for which the analysis has to be run. Should be either :length_1 or :length2
            # @param analysis_results [Hash] The analysis results
            def call
              return unless footing.reinforcement_ratio(direction: analysis_direction, above_middle: false).nil?

              optimized_rebar = run_optimization
              if optimized_rebar.result_code == critical_result_code
                return context.fail!(message: "rebar couldn't be found")
              end

              add_reinforcement_to_footing(optimized_rebar)
            end

            private

            def run_optimization
              StructuraidCore::Optimization::RebarWithConstantLength
                .new(required_reinforcement_area,
                     max_rebar_spacing,
                     distribution_length,
                     100).run
            end

            def max_rebar_spacing
              context.design_code::Rc::Footings::MaximumRebarSpacing.call(
                support_type: context.support_type, footing_height: footing.height,
                for_min_rebar: context.analysis_results[:is_minimum_ratio], yield_stress: context.steel.yield_stress,
                reinforcement_cover: footing.cover_bottom
              )
            end

            def required_reinforcement_area
              context.analysis_results[:computed_ratio] *
                footing.width(analysis_direction) *
                (footing.height - reinforcement_baseline)
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
              return footing.cover_bottom unless secondary_direction_reinforcement

              footing.cover_bottom + secondary_direction_reinforcement.max_diameter
            end

            def add_reinforcement_to_footing(optimized_rebar)
              reinforcement = footing.add_longitudinal_reinforcement(
                Elements::Reinforcement::StraightLongitudinal.new(distribution_direction: secondary_analysis_direction),
                analysis_direction
              )

              reinforcement.add_layer(
                start_location: reinforcement_layer_start_location,
                end_location: reinforcement_layer_end_location,
                amount_of_rebars: optimized_rebar.amount_of_rebars,
                rebar: optimized_rebar.rebar
              )
            end

            def reinforcement_layer_start_location
              case analysis_direction
              when :length_1
                footing.coordinates_system.find_location('reinforcement_layer_start_location_length_1_bottom')
              when :length_2
                footing.coordinates_system.find_location('reinforcement_layer_start_location_length_2_bottom')
              end
            end

            def reinforcement_layer_end_location
              case analysis_direction
              when :length_1
                footing.coordinates_system.find_location('reinforcement_layer_end_location_length_1_bottom')
              when :length_2
                footing.coordinates_system.find_location('reinforcement_layer_end_location_length_2_bottom')
              end
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

            def critical_result_code
              Optimization::RebarWithConstantLength::CRITICAL_RESULT_CODE
            end
          end
        end
      end
    end
  end
end
