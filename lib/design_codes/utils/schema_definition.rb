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

        def validate!(params)
          required.each do |required_param|
            raise DesignCodes::MissingParamError, required_param if params[required_param].nil?
          end

          optional.each do |optional_param|
            raise DesignCodes::MissingParamError, optional_param if params[optional_param].nil?
          rescue DesignCodes::MissingParamError => e
            Warning.warn(e.message)
          end

          true
        end

        def structurize(params)
          structured_args_names = [*required, *optional]
          structured_klass = Struct.new(*structured_args_names, :schema, keyword_init: true)
          sliced_params = params.slice(*structured_args_names)
          sliced_params.merge!(schema: name)

          structured_klass.new(sliced_params)
        end

        private

        def required_params(params)
          @@required = params
        end

        def optional_params(params)
          @@optional = params
        end

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
