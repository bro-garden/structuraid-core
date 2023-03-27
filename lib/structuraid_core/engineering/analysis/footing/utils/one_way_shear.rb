module StructuraidCore
  module Engineering
    module Analysis
      module Footing
        module Utils
          module OneWayShear
            def shear_at(x_distance)
              return [] if x_distance > section_length || x_distance.negative?

              shear = [
                shear_stretch_1(x_distance),
                shear_stretch_2(x_distance),
                shear_stretch_3(x_distance)
              ].select(&:nonzero?)
              return [0] if shear.empty?

              shear
            end

            private

            def shear_stretch_1(x_distance)
              return 0.0 if x_distance > long_border_to_first_column || x_distance.zero?

              -solicitation_load * x_distance
            end

            def shear_stretch_2(x_distance)
              return 0.0 if x_distance < long_border_to_first_column || x_distance > long_border_to_first_column + long_first_column_to_second_column

              -reaction_1 - solicitation_load * x_distance
            end

            def shear_stretch_3(x_distance)
              return 0.0 if x_distance < long_border_to_first_column + long_first_column_to_second_column

              -reaction_2 - reaction_1 - solicitation_load * x_distance
            end
          end
        end
      end
    end
  end
end
