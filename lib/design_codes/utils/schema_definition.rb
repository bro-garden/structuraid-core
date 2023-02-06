require 'errors/design_codes/missing_param_error'

module DesignCodes
  module Utils
    module SchemaDefinition
      def self.included(base)
        base.class_eval do
          extend ClassMethods
        end
      end

      module ClassMethods
        @@required = []
        @@optional = []

        def required_params(params)
          @@required = params
        end

        def optional_params(params)
          @@optional = params
        end

        def validate!(params)
          required.each do |required_param|
            raise DesignCodes::MissingParamError, required_param if params.keys.none?(required_param)
          end

          optional.each do |optional_param|
            raise DesignCodes::MissingParamError, optional_param if params.keys.none?(optional_param)
          rescue DesignCodes::MissingParamError => e
            Warning.warn(e.message)
          end

          true
        end

        def structurize(params)
          structured_args_names = [*required, *optional]

          structured_klass = Struct.new(*structured_args_names)
          structured_args_values = structured_args_names.map { |arg_name| params[arg_name] }

          structured_klass.new(*structured_args_values)
        end

        private

        def required
          @@required
        end

        def optional
          @@optional
        end
      end
    end
  end
end
