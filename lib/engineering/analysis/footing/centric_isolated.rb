require 'errors/engineering/analysis/section_direction_error'

module Engineering
  module Analysis
    module Footing
      class CentricIsolated
        ORTHOGONALITIES = %i[length_x length_y].freeze
        SECTION_DIRECTION_ERROR = 'Not valid cut direction, should one of thes: :length_x :length_y'.freeze

        def initialize(column:, footing:, effective_height:, load_from_column:, section_direction:)
          if ORTHOGONALITIES.none?(section_direction)
            raise Engineering::Analysis::SectionDirectionError.new(section_direction, ORTHOGONALITIES)
          end

          @column = column
          @footing = footing
          @load_from_column = load_from_column
          @effective_height = effective_height.to_f
          @section_direction = section_direction
        end

        def solicitation_load
          solicitation * @footing.public_send(orthogonal_direction)
        end

        def max_shear_solicitation
          solicitation_load * @footing.public_send(@section_direction)
        end

        def shear_solicitation
          footing_section_length = @footing.public_send(@section_direction)
          column_section_length = @column.public_send(@section_direction)

          solicitation_load * (footing_section_length - column_section_length - 2 * @effective_height)
        end

        def bending_solicitation
          0.25 * max_shear_solicitation * @footing.public_send(@section_direction)
        end

        private

        def solicitation
          @load_from_column.value / @footing.horizontal_area
        end

        def orthogonal_direction
          orthogonal = ORTHOGONALITIES - [@cut_direction]
          orthogonal.last
        end
      end
    end
  end
end
