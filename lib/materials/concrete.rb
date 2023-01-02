require './lib/materials/base'

module Materials
  class Concrete < Base
    attr_reader :elastic_module, :design_compression_strength, :specific_weight

    def self.new_reinfoced_concrete(elastic_module:, design_compression_strength:)
      concrete = new(elastic_module:, design_compression_strength:)
      concrete.reinforced_concrete

      concrete
    end

    def self.new_simple_concrete(elastic_module:, design_compression_strength:)
      concrete = new(elastic_module:, design_compression_strength:)
      concrete.simple_concrete

      concrete
    end

    def initialize(elastic_module:, design_compression_strength:)
      @elastic_module = elastic_module.to_f
      @design_compression_strength = design_compression_strength.to_f
      @specific_weight = nil
    end

    def reinforced_concrete
      @specific_weight = 24.0
    end

    def simple_concrete
      @specific_weight = 20.0
    end
  end
end
