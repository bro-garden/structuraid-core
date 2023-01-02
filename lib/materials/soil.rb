require './lib/materials/base'

module Materials
  class Soil < Base
    attr_reader :bearing_capacity

    def initialize(bearing_capacity:)
      @bearing_capacity = bearing_capacity.to_f
    end
  end
end
