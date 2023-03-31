module StructuraidCore
  module Engineering
    module Analysis
      module Footing
        class Base
        end
      end
    end
  end
end

require_relative 'utils/basic_geometry'
require_relative 'utils/centroid'
require_relative 'utils/one_way_shear'
require_relative 'utils/one_way_moment'
require_relative 'centric_isolated'
require_relative 'centric_combined_two_columns'
