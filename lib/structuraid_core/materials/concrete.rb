module StructuraidCore
  module Materials
    # This class represents a concrete material
    class Concrete
      attr_reader :elastic_module, :design_compression_strength, :specific_weight

      def initialize(elastic_module:, design_compression_strength:, specific_weight:)
        @elastic_module = elastic_module.to_f
        @design_compression_strength = design_compression_strength.to_f
        @specific_weight = specific_weight.to_f
      end
    end
  end
end
