require 'errors/engineering/array_operation_error'

module Engineering
  class Array < Array
    def *(other)
      run_validations_against(other)
    end

    private

    def run_validations_against(other)
      validate_arrays
      other.send(:validate_arrays)
      other.send(:valid_size_with?, first.size)
    end

    def validate_arrays
      unless all? { |row| row.class.to_s == 'Array' }
        raise Engineering::ArrayOperationError.new(operation_key: :array_of_arrays)
      end

      base_size = first.size

      return if all? { |row| row.size == base_size }

      raise Engineering::ArrayOperationError.new(operation_key: :self_size)
    end

    def valid_size_with?(a_array_size)
      return true if a_array_size == size

      raise Engineering::ArrayOperationError.new(operation_key: :other_size)
    end
  end
end
