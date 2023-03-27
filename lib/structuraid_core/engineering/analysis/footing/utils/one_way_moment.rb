module StructuraidCore
  module Engineering
    module Analysis
      module Footing
        module Utils
          module OneWayMoment
            def moment_at(x_distance)
              return [] if x_distance > section_length

              moment = [
                moment_stretch_1(x_distance),
                moment_stretch_2(x_distance),
                moment_stretch_3(x_distance)
              ].select(&:nonzero?)
              return [0] if moment.empty?

              moment
            end

            def maximum_moment
              moment_at(moment_inflection_point)
            end

            def moment_inflection_point
              -reaction_1 / solicitation_load
            end

            private

            def moment_stretch_1(x_distance)
              return 0.0 if x_distance > long_border_to_first_column

              0.5 * solicitation_load * x_distance**2
            end

            def moment_stretch_2(x_distance)
              return 0.0 if x_distance < long_border_to_first_column || x_distance > long_border_to_first_column + long_first_column_to_second_column

              0.5 * solicitation_load * x_distance**2 + reaction_1 * (x_distance - long_border_to_first_column)
            end

            def moment_stretch_3(x_distance)
              return 0.0 if x_distance < long_border_to_first_column + long_first_column_to_second_column

              0.5 * solicitation_load * x_distance**2 + reaction_1_moment(x_distance) + reaction_2_moment(x_distance)
            end

            def reaction_1_moment(x_distance)
              reaction_1 * (x_distance - long_border_to_first_column)
            end

            def reaction_2_moment(x_distance)
              reaction_2 * (x_distance - long_border_to_first_column - long_first_column_to_second_column)
            end
          end
        end
      end
    end
  end
end
