module StructuraidCore
  module Engineering
    module Analysis
      module Footing
        module Utils
          module Centroid
            def absolute_centroid
              Engineering::Locations::Absolute.new(
                value_x: moment_yy / total_load,
                value_y: moment_xx / total_load,
                value_z: loads_from_columns.first.location.value_z
              )
            end

            private

            def moment_yy
              loads_from_columns.sum { |load| load.value * load.location.value_x }
            end

            def moment_xx
              loads_from_columns.sum { |load| load.value * load.location.value_y }
            end

            def total_load
              loads_from_columns.sum(&:value)
            end
          end
        end
      end
    end
  end
end
