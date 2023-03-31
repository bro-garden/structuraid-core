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
              -reaction_at_first_column / solicitation_load
            end

            private

            def moment_stretch_1(x_distance)
              return 0.0 if x_distance > length_border_to_first_column

              0.5 * solicitation_load * x_distance**2
            end

            def moment_stretch_2(x_distance)
              local_length_1 = length_border_to_first_column
              local_length_2 = length_first_column_to_second_column
              return 0.0 if x_distance < local_length_1 || x_distance > local_length_1 + local_length_2

              0.5 * solicitation_load * x_distance**2 + reaction_at_first_column * (x_distance - local_length_1)
            end

            def moment_stretch_3(x_distance)
              return 0.0 if x_distance < length_border_to_first_column + length_first_column_to_second_column

              0.5 * solicitation_load * x_distance**2 + reaction_1_moment(x_distance) + reaction_2_moment(x_distance)
            end

            def reaction_1_moment(x_distance)
              reaction_at_first_column * (x_distance - length_border_to_first_column)
            end

            def reaction_2_moment(x_distance)
              local_length_2 = length_first_column_to_second_column
              reaction_at_second_column * (x_distance - length_border_to_first_column - local_length_2)
            end
          end
        end
      end
    end
  end
end
