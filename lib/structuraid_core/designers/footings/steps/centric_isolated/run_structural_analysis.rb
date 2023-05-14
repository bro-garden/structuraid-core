require 'interactor'

module StructuraidCore
  module Designers
    module Footings
      module Steps
        module CentricIsolated
          # Runs the structural analysis for a centric isolated footing, generating the internal forces needed for design
          class RunStructuralAnalysis
            include Interactor

            # @param footing [StructuraidCore::Elements::Footing] The footing to be designed
            # @param load_scenario [StructuraidCore::Loads::Scenarios::Footings::CentricIsolated] The load scenario to be considered
            def call
            end
          end
        end
      end
    end
  end
end
