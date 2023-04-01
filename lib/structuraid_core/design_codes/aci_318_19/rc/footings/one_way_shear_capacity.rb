module StructuraidCore
  module DesignCodes
    module ACI31819
      module RC
        module Footings
          class OneWayShearCapacity
            CODE_REFERENCE = 'ACI 318-19'.freeze

            include DesignCodes::Utils::CodeRequirement
            use_schema DesignCodes::Schemas::RC::Footings::OneWayShearCapacitySchema

            def call
              compute_concrete_shear_capacity
            end

            private

            def compute_concrete_shear_capacity
              effective_area = effective_height * width
              concrete_strength = light_concrete_modification_factor * Math.sqrt(design_compression_strength)

              0.17 * concrete_strength * effective_area
            end
          end
        end
      end
    end
  end
end
