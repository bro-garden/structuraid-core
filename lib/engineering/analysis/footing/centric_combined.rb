require 'errors/engineering/analysis/section_direction_error'

module Engineering
  module Analysis
    module Footing
      class CentricCombined
        ORTHOGONALITIES = %i[length_1 length_2].freeze

        def initialize(footing:, loads_from_columns:, section_direction:)
          if ORTHOGONALITIES.none?(section_direction)
            raise Engineering::Analysis::SectionDirectionError.new(section_direction, ORTHOGONALITIES)
          end

          @footing = footing
          @loads_from_columns = loads_from_columns
          @section_direction = section_direction
        end

        def solicitation_load
          solicitation * @footing.public_send(orthogonal_direction)
        end

        def max_shear_solicitation
          solicitation_load * @footing.public_send(@section_direction)
        end

        private

        def solicitation
          @loads_from_columns.sum(&:value) / @footing.horizontal_area
        end

        def orthogonal_direction
          orthogonal = ORTHOGONALITIES - [@cut_direction]
          orthogonal.last
        end
      end
    end
  end
end
