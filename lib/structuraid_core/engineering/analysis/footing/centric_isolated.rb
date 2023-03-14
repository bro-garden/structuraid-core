module StructuraidCore
  module Engineering
    module Analysis
      module Footing
        class CentricIsolated
          ORTHOGONALITIES = %i[length_1 length_2].freeze

          def initialize(footing:, load_from_column:, section_direction:)
            if ORTHOGONALITIES.none?(section_direction)
              raise StructuraidCore::Engineering::Analysis::SectionDirectionError.new(section_direction, ORTHOGONALITIES)
            end

            @footing = footing
            @load_from_column = load_from_column
            @section_direction = section_direction
          end

          def solicitation_load
            solicitation * orthogonal_length
          end

          def max_shear_solicitation
            solicitation_load * section_length
          end

          def shear_solicitation_at(distance_from_footing_center:)
            footing_section_length = section_length

            solicitation_load * (footing_section_length - distance_from_footing_center)
          end

          def bending_solicitation
            0.25 * max_shear_solicitation * section_length
          end

          private

          attr_reader :footing, :load_from_column, :section_direction

          def section_length
            footing.public_send(section_direction)
          end

          def orthogonal_length
            footing.public_send(orthogonal_direction)
          end

          def solicitation
            load_from_column.value / footing.horizontal_area
          end

          def orthogonal_direction
            orthogonal = ORTHOGONALITIES - [section_direction]
            orthogonal.last
          end
        end
      end
    end
  end
end
