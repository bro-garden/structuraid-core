module StructuraidCore
  module Loads
    module Scenarios
      module Footings
        # This class will encapsulate the load data for a given scenario of a combinated two columns footing
        class CentricCombinedTwoColumns
          attr_reader :ultimate_loads, :service_loads

          # @param ultimate_loads [Array<Loads::PointLoad>] The ultimate loads that the columns transmit to the footing
          # @param service_loads [Array<Loads::PointLoad>] The service loads that the columns transmit to the footing
          def initialize(ultimate_loads:, service_loads:)
            @ultimate_loads = ultimate_loads
            @service_loads = service_loads
          end
        end
      end
    end
  end
end
