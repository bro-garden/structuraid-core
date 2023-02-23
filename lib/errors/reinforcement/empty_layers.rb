module Elements
  module Reinforcement
    class EmptyLayers < StandardError
      def initialize(complement)
        message = "There are no layers #{complement}"

        super(message)
      end
    end
  end
end
