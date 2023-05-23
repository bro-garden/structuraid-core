module StructuraidCore
  module Loads
    # This class represents a point load
    class PointLoad
      attr_accessor :value
      attr_reader :location, :label

      def initialize(value:, location:, label: nil)
        @value = value.to_f
        @location = location
        @label = label&.to_sym
      end
    end
  end
end
