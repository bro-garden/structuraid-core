require 'errors/engineering/array_operation_error'

module Engineering
  class Array < Array
    def initialize(*rows)
      super(rows)
    end

    def *(other)
      run_validations_against(other)
      assemble_answer(other)
    end

    def -(other)
      unless array_size == other.array_size
        raise Engineering::ArrayOperationError.new(operation_key: :diferent_size)
      end

      Engineering::Array.new(*sum_from_self(other, :diff))
    end

    def +(other)
      unless array_size == other.array_size
        raise Engineering::ArrayOperationError.new(operation_key: :diferent_size)
      end

      Engineering::Array.new(*sum_from_self(other, :sum))
    end

    def array_size
      {
        rows: size,
        columns: first.size
      }
    end

    private

    def assemble_answer(other)
      answer = Engineering::Array.new([])

      other.first.size.times do |other_column_index|
        size.times do |self_row_index|
          answer[self_row_index] = [] unless answer[self_row_index]
          answer[self_row_index][other_column_index] = [] unless answer[self_row_index][other_column_index]

          answer[self_row_index][other_column_index] = sum_values(other, self_row_index, other_column_index)
        end
      end

      answer
    end

    def sum_from_self(other, operation = :sum)
      answer = []

      size.times do |row_index|
        answer << []
        modified_other_row = modify_row_items(other[row_index], operation)

        answer[row_index] = self[row_index].zip(modified_other_row).map(&:sum)
      end

      answer
    end

    def modify_row_items(row, operation)
      if operation == :diff
        row.map { |column| column * -1 }
      else
        row
      end
    end

    def sum_values(other, self_row_index, other_column_index)
      value_of_index = 0
      self[self_row_index].size.times do |index|
        value_of_index += self[self_row_index][index] * other[index][other_column_index]
      end

      value_of_index
    end

    def run_validations_against(other)
      validate_arrays
      other.send(:validate_arrays)
      other.send(:valid_size_with?, first.size)
      validate_columns_rows(other)
    end

    def validate_columns_rows(other)
      return if array_size[:columns] == other.array_size[:rows]

      raise Engineering::ArrayOperationError.new(operation_key: :columns_rows)
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
