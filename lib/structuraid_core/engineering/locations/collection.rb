module StructuraidCore
  module Engineering
    module Locations
      class Collection < Base
        include Enumerable

        def initialize
          @locations = []
        end

        def each(&block)
          locations.each(&block)
        end

        def add(location)
          raise DuplicateLabelError, location.label if location.label && find_by_label(location.label)

          locations.push(location)
        end

        def inspect
          locations.inspect
        end

        def find_by_label(label)
          locations.find { |location| location.label == label }
        end

        private

        attr_reader :locations
      end
    end
  end
end
