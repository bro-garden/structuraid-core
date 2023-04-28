module StructuraidCore
  module DesignCodes
    module Utils
      module SchemaDefinition
        def self.included(base)
          base.class_eval do
            extend ClassMethods
          end
        end

        module ClassMethods
          def validate!(params)
            validate_required_params!(params)
            validate_optional_params!(params)
            validate_enum_params!(params)

            true
          end

          def structurize(params)
            structured_args_names = [*required, *optional]
            structured_klass = Struct.new(*structured_args_names, :schema, keyword_init: true)
            sliced_params = params.slice(*structured_args_names)
            sliced_params.merge!(schema: name)

            structured_klass.new(sliced_params)
          end

          def required
            @required
          end

          def optional
            @optional
          end

          def enum_params
            @enum_params
          end

          private

          def validate_required_params!(params)
            required.each do |required_param|
              raise DesignCodes::MissingParamError, required_param if params[required_param].nil?
            end
          end

          def validate_optional_params!(params)
            optional.each do |optional_param|
              raise DesignCodes::MissingParamError, optional_param if params[optional_param].nil?
            rescue DesignCodes::MissingParamError => e
              Warning.warn(e.message)
            end
          end

          def validate_enum_params!(params)
            enum_params&.each do |enum_param|
              param_name = enum_param[:name]
              param_value = params[param_name]
              next if param_value.nil? && optional.include?(param_name)

              if enum_param[:values].none?(param_value)
                raise DesignCodes::UnrecognizedValueError.new(param_name, param_value)
              end
            end
          end

          def required_params(params)
            @required = params
          end

          def optional_params(params)
            @optional = params
          end

          def enum(param_name, values)
            @enum_params = []
            @enum_params << { name: param_name, values: }
          end
        end
      end
    end
  end
end
