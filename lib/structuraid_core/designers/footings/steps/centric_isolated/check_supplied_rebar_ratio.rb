require 'interactor'

module StructuraidCore
  module Designers
    module Footings
      module Steps
        module CentricIsolated
          # Runs the structural bending analysis and design for a centric isolated footing, generating the required reinforcement ratio and checking that the provided one is enough
          class CheckSuppliedRebarRatio
            include Interactor

            # @param footing [StructuraidCore::Elements::Footing] The footing to be designed

            # @param design_code [StructuraidCore::DesignCodes] The design code to be used
            def call

            rescue Errors::DesignCodes::RequirementNotFulfilledError => e
              context.fail!(message: e.message)
            end

            private

            def analysis_results
              @analysis_results ||= context.analysis_results
            end

            def analysis_direction
              @analysis_direction ||= context.analysis_direction
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
