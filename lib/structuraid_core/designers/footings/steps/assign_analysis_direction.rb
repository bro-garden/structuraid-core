require 'interactor'

module StructuraidCore
  module Designers
    module Footings
      module Steps
        # Assigns the direction for the footing analysis. It can be either length_1 or length_2, depending on wether the analysis has run for the first or second time
        class AssignAnalysisDirection
          include Interactor
          include Interactor::ContextReader

          context_params :analysis_length_1, :analysis_length_2

          # @param analysis_length_1 [Boolean optional] Wether the analysis has run for the length_1 section or not
          # @param analysis_length_2 [Boolean optional] Wether the analysis has run for the length_2 section or not
          def call
            return context.analysis_direction = :length_1 if analysis_length_1.nil? && analysis_length_2.nil?
            return context.analysis_direction = :length_2 if analysis_length_2.nil?

            context.fail!(message: 'Analysis has been run for all directions already')
          end
        end
      end
    end
  end
end
