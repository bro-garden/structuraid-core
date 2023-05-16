require 'interactor'

module StructuraidCore
  module Designers
    module Footings
      module Steps
        # Checks if the bearing capacity of the soil is not being exceeded by the footing and its transmitting load
        class CheckBearingCapacity
          include Interactor

          # @param footing [StructuraidCore::Elements::Footing] The footing to be designed
          # @param load_scenario [StructuraidCore::Loads::Scenarios::] The load scenario to be considered
          # @param soil [StructuraidCore::Materials::Soil] The soil layer on which the footer is supported
          def call
            soil_area_load = area_service_load + footing_self_weigth
            return if soil_area_load <= bearing_capacity

            context.fail!(message: "Soil bearing capacity exceeded. #{soil_area_load} > #{bearing_capacity}")
          end

          private

          def area_service_load
            load_scenario.total_service_load.value.abs / footing.horizontal_area
          end

          def footing_self_weigth
            footing.material.specific_weight * footing.height
          end

          def bearing_capacity
            @bearing_capacity ||= context.soil.bearing_capacity
          end

          def load_scenario
            @load_scenario ||= context.load_scenario
          end

          def footing
            @footing ||= context.footing
          end
        end
      end
    end
  end
end
