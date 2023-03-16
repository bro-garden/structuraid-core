module StructuraidCore
  module Engineering
    module Analysis
      module Footing
        module Utils
          module TwoColumnsShearMomentum
            def shear_at(x_distance)
              return [] if x_distance > section_length || x_distance.negative?

              [
                shear_stretch_1(x_distance),
                shear_stretch_2(x_distance),
                shear_stretch_3(x_distance)
              ]
            end

            def moment_at(x_distance)
              return [] if x_distance > section_length

              [
                moment_stretch_1(x_distance),
                moment_stretch_2(x_distance),
                moment_stretch_3(x_distance)
              ]
            end

            private

            def shear_stretch_1(x_distance)
              return 0.0 if x_distance > long_stretch_1 || x_distance.zero?

              -solicitation_load * x_distance
            end

            def shear_stretch_2(x_distance)
              return 0.0 if x_distance < long_stretch_1 || x_distance > long_stretch_1 + long_stretch_2

              -reaction_1 - solicitation_load * x_distance
            end

            def shear_stretch_3(x_distance)
              return 0.0 if x_distance < long_stretch_1 + long_stretch_2

              -reaction_2 - reaction_1 - solicitation_load * x_distance
            end

            def moment_stretch_1(x_distance)
              return 0.0 if x_distance > long_stretch_1

              0.5 * solicitation_load * x_distance**2
            end

            def moment_stretch_2(x_distance)
              return 0.0 if x_distance < long_stretch_1 || x_distance > long_stretch_1 + long_stretch_2

              0.5 * solicitation_load * x_distance**2 + reaction_1 * (x_distance - long_stretch_1)
            end

            def moment_stretch_3(x_distance)
              return 0.0 if x_distance < long_stretch_1 + long_stretch_2

              0.5 * solicitation_load * x_distance**2 + reaction_2 * (x_distance - long_stretch_1 - long_stretch_2)
            end
          end
        end
      end
    end
  end
end