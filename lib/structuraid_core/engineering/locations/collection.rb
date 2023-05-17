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
          raise Errors::Engineering::Locations::DuplicateLabelError, location.label if find_by_label(location.label)

          locations.push(location)
        end

        def inspect
          locations.inspect
        end

        def find_by_label(label)
          locations.find { |location| location.label == label.to_sym }
        end

        def last
          locations.last
        end

        def prepend(location)
          locations.prepend(location)
        end

        def find_or_add_by_label(location)
          add(location)
          find_by_label(location.label)
        rescue Errors::Engineering::Locations::DuplicateLabelError => e
          Warning.warn(e.message)
          find_by_label(location.label)
        end

        private

        attr_reader :locations
      end
    end
  end
end
