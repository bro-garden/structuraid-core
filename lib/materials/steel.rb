module Materials
  class Steel < Base
    DEFAULT_ELASTIC_MODULE = 200_000

    attr_reader :elastic_module, :yield_stress

    def initialize(elastic_module: DEFAULT_ELASTIC_MODULE, yield_stress:)
      @elastic_module = elastic_module.to_f
      @yield_stress = yield_stress.to_f
    end
  end
end
