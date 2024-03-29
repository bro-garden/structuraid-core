require 'interactor'

module StructuraidCore
  module Designers
    module Footings
      module Steps
        # Resolves the design code namespace to be used
        class ResolveDesignCode
          include Interactor

          # @param design_code [Symbol or String] The design code to be used
          def call
            context.design_code = DesignCodes::Resolver.use(context.design_code)
          rescue Errors::DesignCodes::UnknownDesignCodeError => e
            context.fail!(message: e.message)
          end
        end
      end
    end
  end
end
