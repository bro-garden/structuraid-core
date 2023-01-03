require 'db/base'
require 'elements/steel_reinforcement/base'

module Elements
  module SteelReinforcement
    class RebarHook < Base
      attr_accessor :angle

      def initialize(number:, material:, standard_bars:)
        @angle = nil

        super(number:, material:, standard_bars:)
      end
    end
  end
end
