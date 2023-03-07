require 'spec_helper'
require 'engineering/array'
require 'errors/engineering/array_operation_error'
require 'byebug'

RSpec.describe Engineering::Array do
  describe '#*' do
    describe 'when a is not an array of multiple dimension' do
      let(:a) { described_class.new [1, 2, 3, 4, 5, 6, 7, 8, 9] }
      let(:b) { described_class.new [2, 3, 5] }

      it 'raises an error' do
        expect { a * b }.to raise_error(Engineering::ArrayOperationError)
      end
    end

    describe 'when b is not an array of multiple dimension' do
      let(:a) { described_class.new [[1, 2, 3], [4, 5, 6], [7, 8, 9]] }
      let(:b) { described_class.new [2, 3, 5] }

      it 'raises an error' do
        expect { a * b }.to raise_error(Engineering::ArrayOperationError)
      end
    end

    describe 'when a and b are arrays of multiple dimension' do
      describe 'when each item of any of the arrays (a or b) has no the same size of the other one' do
        let(:a) { described_class.new [[1, 2, 3], [5, 6], [7, 8, 9]] }
        let(:b) { described_class.new [[2], [3], [5]] }

        it 'raises an error' do
          expect { a * b }.to raise_error(Engineering::ArrayOperationError)
        end
      end

      describe "when amount of columns of 'a' ar diferent from amount of rows of 'b'" do
        let(:a) { described_class.new [[1, 2, 3], [5, 6, 7], [7, 8, 9]] }
        let(:b) { described_class.new [[2], [3]] }

        it 'raises an error' do
          expect { a * b }.to raise_error(Engineering::ArrayOperationError)
        end
      end

      describe 'when sizes are right' do
        let(:a) { described_class.new [[1, 2, 3], [4, 5, 6], [7, 8, 9]] }
        let(:b) { described_class.new [[2], [3], [5]] }

        it 'BLABLABLABLA raises an error' do
          expect { a * b }.not_to raise_error(Engineering::ArrayOperationError)
        end
      end
    end
  end
end
