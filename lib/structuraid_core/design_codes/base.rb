module StructuraidCore
  module DesignCodes
    class Base
    end
  end
end

require 'require_all'
require_relative 'utils/code_requirement'
require_relative 'utils/schema_definition'
require_all 'lib/structuraid_core/design_codes/schemas'
require_all 'lib/structuraid_core/design_codes/nsr_10'
require_all 'lib/structuraid_core/design_codes/aci_318_19'
require_all 'lib/structuraid_core/errors/design_codes'
require_relative 'resolver'
