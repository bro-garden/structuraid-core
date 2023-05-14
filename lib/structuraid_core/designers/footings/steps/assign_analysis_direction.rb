require 'interactor'

module StructuraidCore
  module Designers
    module Footings
      module Steps
        # Assigns the direction for the footing analysis. It can be either length_1 or length_2, depending on wether the analysis has run for the first or second time
        class AssignAnalysisDirection
          include Interactor

          # @param analysis_length_1 [Boolean optional] Wether the analysis has run for the length_1 section or not
          # @param analysis_length_2 [Boolean optional] Wether the analysis has run for the length_2 section or not
          def call
          end
        end
      end
    end
  end
end
