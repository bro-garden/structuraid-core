module Interactor
  # This module allows to define the context params that will be used by the interactor
  module ContextReader
    def self.included(base)
      base.class_eval do
        extend ClassMethods
      end
    end

    # Defines some class methods that will be used by the interactor when the context is read
    module ClassMethods
      def context_params(*names)
        names.each do |name|
          define_method(name) do
            raise ArgumentError, "Missing context param #{name}" unless context.respond_to?(name)

            context.public_send(name)
          end
        end
      end
    end
  end
end
