module StructuraidCore
  module Errors
    module Reinforcement
      class InvalidDistributionDirection < StandardError
        def initialize(distribution_direction, valid_directions)
          message = "#{distribution_direction} is not a valid direction, should one of #{valid_directions}"

          super(message)
        end
      end
    end
  end
end
