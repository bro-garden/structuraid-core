module StructuraidCore
  module Loads
    module Scenarios
      module Footings
        # This class will encapsulate the load data for a given scenario of a centric isolated footing
        class CentricIsolated
          attr_reader :ultimate_load, :service_load

          # @param ultimate_load [Loads::PointLoad] The ultimate load that the column transmits to the footing
          # @param service_load [Loads::PointLoad] The service load that the column transmits to the footing
          def initialize(ultimate_load:, service_load:)
            @ultimate_load = ultimate_load
            @service_load = service_load
          end

          def total_service_load
            service_load
          end

          def total_ultimate_load
            ultimate_load
          end
        end
      end
    end
  end
end
