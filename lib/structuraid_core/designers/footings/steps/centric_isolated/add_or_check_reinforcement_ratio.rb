require 'interactor'

module StructuraidCore
  module Designers
    module Footings
      module Steps
        module CentricIsolated
          # Resolves what to run in the design flow: add reinforcement or check reinforcement ratio
          class AddOrCheckReinforcementRatio
            include Interactor

            # @param footing [StructuraidCore::Elements::Footing] The footing to be designed
            # @param analysis_direction [Symbol] The direction for which the analysis has to be run. Should be either :length_1 or :length2
            # @param analysis_results [Hash] The analysis results
            def call

            end
          end
        end
      end
    end
  end
end
