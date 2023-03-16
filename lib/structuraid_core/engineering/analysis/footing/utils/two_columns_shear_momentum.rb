module StructuraidCore
  module Engineering
    module Analysis
      module Footing
        module Utils
          module TwoColumnsShearMomentum
            def shear_at(x_distance)
              return [] if x_distance > section_length || x_distance.negative?

              [
                shear_first_stretch(x_distance),
                shear_second_stretch(x_distance),
                shear_third_stretch(x_distance)
              ]
            end

            def moment_at(x_distance)
              return [] if x_distance > section_length

              [
                moment_first_stretch(x_distance),
                moment_second_stretch(x_distance),
                moment_third_stretch(x_distance)
              ]
            end

            private

            def shear_first_stretch(x_distance)
              return 0.0 if x_distance > long_1 || x_distance.zero?

              -solicitation_load * x_distance
            end

            def shear_second_stretch(x_distance)
              return 0.0 if x_distance < long_1 || x_distance > long_1 + long_2

              -reaction_1 - solicitation_load * x_distance
            end

            def shear_third_stretch(x_distance)
              return 0.0 if x_distance < long_1 + long_2

              -reaction_2 - reaction_1 - solicitation_load * x_distance
            end

            def moment_first_stretch(x_distance)
              return 0.0 if x_distance > long_1

              0.5 * solicitation_load * x_distance**2
            end

            def moment_second_stretch(x_distance)
              return 0.0 if x_distance < long_1 || x_distance > long_1 + long_2

              0.5 * solicitation_load * x_distance**2 + reaction_1 * (x_distance - long_1)
            end

            def moment_third_stretch(x_distance)
              return 0.0 if x_distance < long_1 + long_2

              0.5 * solicitation_load * x_distance**2 + reaction_2 * (x_distance - long_1 - long_2)
            end
          end
        end
      end
    end
  end
end
