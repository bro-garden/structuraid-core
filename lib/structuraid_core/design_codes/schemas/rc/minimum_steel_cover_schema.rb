module StructuraidCore
  module DesignCodes
    module Schemas
      module Rc
        class MinimumSteelCoverSchema
          include DesignCodes::Utils::SchemaDefinition

          required_params %i[
            concrete_casting_against_soil
            environment_exposure
          ]

          optional_params %i[
            maximum_rebar_diameter
            structural_element
          ]

          enum :structural_element, %i[
            slab
            wall
            joist
            beam
            column
            shell thin_shell
            tensor_joint
            pedestal
          ]
        end
      end
    end
  end
end
