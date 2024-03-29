module StructuraidCore
  module DesignCodes
    module Nsr10
      module Rc
        module Footings
          class PunchingShearCapacity
            COLUMN_LOCATION_FACTORS = {
              interior: 40,
              border: 30,
              corner: 20
            }.freeze

            include DesignCodes::Utils::CodeRequirement
            use_schema DesignCodes::Schemas::Rc::Footings::PunchingShearCapacitySchema

            # NSR-10 C.11.11.2.1
            def call
              [
                basic_shear_capacity,
                shear_capacity_modified_by_column_size,
                shear_capacity_modified_by_column_location
              ].min
            end

            private

            def basic_shear_capacity
              @basic_shear_capacity ||= 0.33 * Math.sqrt(design_compression_strength) *
                                        light_concrete_modification_factor *
                                        critical_section_perimeter *
                                        effective_height
            end

            def shear_capacity_modified_by_column_size
              @shear_capacity_modified_by_column_size ||= 0.17 * Math.sqrt(design_compression_strength) *
                                                          light_concrete_modification_factor *
                                                          critical_section_perimeter *
                                                          effective_height *
                                                          (1 + 2 / column_aspect_ratio)
            end

            def shear_capacity_modified_by_column_location
              @shear_capacity_modified_by_column_location ||= 0.083 * Math.sqrt(design_compression_strength) *
                                                              light_concrete_modification_factor *
                                                              critical_section_perimeter *
                                                              effective_height *
                                                              column_location_factor
            end

            def column_aspect_ratio
              @column_aspect_ratio ||= column_sizes.max / column_sizes.min
            end

            def column_sizes
              @column_sizes ||= [column_section_width.to_f, column_section_height.to_f]
            end

            def column_location_factor
              unless COLUMN_LOCATION_FACTORS.keys.include?(column_location)
                raise Errors::DesignCodes::UnrecognizedValueError.new('column_location', column_location)
              end

              @column_location_factor ||= COLUMN_LOCATION_FACTORS[column_location].to_f *
                                          effective_height / critical_section_perimeter + 2
            end
          end
        end
      end
    end
  end
end
