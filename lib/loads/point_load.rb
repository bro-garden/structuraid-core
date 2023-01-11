require 'loads/base'

module Loads
  class PointLoad < Base
    attr_accessor :value
    attr_reader :location

    def initialize(value:, location:)
      @value = value
      @location = location
    end
  end
end
