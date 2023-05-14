require 'interactor'
require_relative './steps/check_bearing_capacity'
require_relative './steps/resolve_design_code'

module StructuraidCore
  module Designers
    module Footings
      # Runs the design process for a centric isolated footing. The footing is expected to have defined dimensions. The design process will just return the reinforcement disposition and wether it passes or not the design requirements
      class CentricIsolated
        include Interactor::Organizer

        # @param footing [StructuraidCore::Elements::Footing] The footing to be designed. It needs to have length_1, length_2, height and material defined
        # @param load_scenario [StructuraidCore::Loads::Scenarios::Footings::CentricIsolated] The load scenario to be considered
        # @param soil [StructuraidCore::Materials::Soil] The soil layer on which the footer is supported
        # @param design_code [Symbol or String] The design code to be used
        organize Steps::ResolveDesignCode,
                 Steps::CheckBearingCapacity
      end
    end
  end
end
