# frozen_string_literal: true

require_relative 'structuraid_core/version'

module StructuraidCore
end

require_relative 'structuraid_core/db/base'
require_relative 'structuraid_core/errors/base'
require_relative 'structuraid_core/design_codes/base'
require_relative 'structuraid_core/loads/base'
require_relative 'structuraid_core/materials/base'
require_relative 'structuraid_core/engineering/base'
require_relative 'structuraid_core/elements/base'

require 'matrix'
