module Engineering
  module Analysis
    module Footing
      class CentricIsolated
        ORTHOGONALITIES = %i[length_x length_y].freeze
        CUT_DIRECTION_ERROR = 'Not valid cut direction, should one of thes: :length_x :length_y'.freeze

        def initialize(column:, footing:, effective_height:, load_from_column:, cut_direction:)
          @column = column
          @footing = footing
          @load_from_column = load_from_column
          @effective_height = effective_height.to_f

          raise ArgumentError, CUT_DIRECTION_ERROR unless ORTOGONALITIES.any?(cut_direction)

          @cut_direction = cut_direction
        end

        def solicitation_load
          solicitation * @footing.send(ortogonal_direction)
        end

        def max_shear_solicitation
          solicitation_load * @footing.send(@cut_direction)
        end

        def shear_solicitation
          solicitation_load * (@footing.send(@cut_direction) - @column.send(@cut_direction) - 2 * @effective_height)
        end

        def bending_solicitation
          0.25 * max_shear_solicitation * @footing.send(@cut_direction)
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
