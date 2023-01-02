module Materials
  class Concrete < Base
    attr_reader :elastic_module, :design_compression_strength

    def initialize(elastic_module:, design_compression_strength:)
      @elastic_module = elastic_module
      @design_compression_strength = design_compression_strength
    end
  end
end
