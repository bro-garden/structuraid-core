module Engineering
  module Analysis
    module Footing
      class CentricIsolated
        ORTOGONALITIES = %i[length_x length_y].freeze

        def initialize(column:, footing:, load_from_column:, cut_direction:)
          @column = column
          @footing = footing
          @load_from_column = load_from_column
          @cut_direction = cut_direction
        end

        def solicitation
          @load_from_column.value / @footing.horizontal_area
        end

        def solicitation_load(length_ortogonal_to_cut)
          solicition * length_ortogonal_to_cut
        end

        def ortogonal_direction
          ortogonal = ORTOGONALITIES - [@cut_direction]
          ortogonal.last
        end
      end
    end
  end
end
