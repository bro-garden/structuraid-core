require 'loads/base'

module Loads
  class PointLoad < Base
    attr_accessor :value
    attr_reader :location

    def initialize(value:, location:)
      @value = value.to_f
      @location = location
    end
  end
end
