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

require_relative 'utils/data'
require_relative 'utils/centroid'
require_relative 'utils/shear_moment'
require_relative 'centric_isolated'
require_relative 'centric_combined_two_columns'
