module StructuraidCore
  module Errors
    class Base < StandardError
    end
  end
end

require_relative 'design_codes/missing_param_error'
require_relative 'design_codes/unknown_design_code_error'
require_relative 'engineering/analysis/section_direction_error'
require_relative 'reinforcement/empty_layers'
require_relative 'reinforcement/invalid_distribution_direction'
