module StructuraidCore
  module Materials
    class Steel
      DEFAULT_ELASTIC_MODULE = 200_000

      attr_reader :elastic_module, :yield_stress

      def initialize(yield_stress:, elastic_module: DEFAULT_ELASTIC_MODULE)
        @elastic_module = elastic_module.to_f
        @yield_stress = yield_stress.to_f
      end
    end
  end
end
