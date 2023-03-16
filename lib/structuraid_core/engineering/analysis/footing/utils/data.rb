module StructuraidCore
  module Engineering
    module Analysis
      module Footing
        module Utils
          module Data
            ORTHOGONALITIES = %i[length_1 length_2].freeze

            def solicitation_load
              solicitation * orthogonal_length
            end

            private

            def section_length
              footing.public_send(section_direction)
            end

            def orthogonal_length
              footing.public_send(orthogonal_direction)
            end

            def orthogonal_direction
              orthogonal = ORTHOGONALITIES - [@cut_direction]
              orthogonal.last
            end

            def solicitation
              loads_from_columns.sum(&:value) / @footing.horizontal_area
            end
          end
        end
      end
    end
  end
end
