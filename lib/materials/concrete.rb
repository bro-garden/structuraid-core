module Materials
  class Concrete < Base
    attr_reader :elastic_module, :design_compression_strength

    def initialize(elastic_module:, design_compression_strength:)
      @elastic_module = elastic_module.to_f
      @design_compression_strength = design_compression_strength.to_f
    end
  end
end
