module StructuraidCore
  module Loads
    # This class represents a uniform load. It has a starting and ending location
    class UniformLoad
      attr_accessor :start_value, :end_value
      attr_reader :start_location

      def initialize(start_value:, end_value:, start_location:, end_location:)
        @start_value = start_value.to_f
        @end_value = end_value.to_f
        @start_location = start_location
        @end_location = end_location
      end
    end
  end
end
