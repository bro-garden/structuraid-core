require 'interactor'

module StructuraidCore
  module Designers
    module Footings
      module Steps
        module CentricIsolated
          # Runs the structural bending analysis and design for a centric isolated footing, generating the required reinforcement ratio and checking that the provided one is enough
          class ComputeRequiredRebarRatio
            include Interactor

            # @param footing [StructuraidCore::Elements::Footing] The footing to be designed
            # @param load_scenario [StructuraidCore::Loads::Scenarios::Footings::CentricIsolated] The load scenario to be considered
            # @param analysis_direction [Symbol] The direction for which the analysis has to be run. Should be either :length_1 or :length2
            # @param design_code [StructuraidCore::DesignCodes] The design code to be used
            def call
            end
          end
        end
      end
    end
  end
end
