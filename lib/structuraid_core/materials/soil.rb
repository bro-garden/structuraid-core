module StructuraidCore
  module Materials
    class Soil
      attr_reader :bearing_capacity

      def initialize(bearing_capacity:)
        @bearing_capacity = bearing_capacity.to_f
      end
    end
  end
end
