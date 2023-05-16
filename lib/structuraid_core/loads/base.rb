module StructuraidCore
  module Loads
    class Base
    end
  end
end

require_relative 'point_load'
require_relative 'uniform_load'
require_all 'lib/structuraid_core/loads/scenarios'
