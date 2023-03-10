require 'spec_helper'
require 'engineering/array'
require 'errors/engineering/array_operation_error'
require 'byebug'

RSpec.describe Engineering::Array do
  describe '#*' do
    describe 'when a is not an array of multiple dimension' do
      let(:a) { described_class.new([1, 2, 3, 4, 5, 6, 7, 8, 9]) }
      let(:b) { described_class.new([2, 3, 5]) }

      it 'raises an error' do
        expect { a * b }.to raise_error(Engineering::ArrayOperationError)
      end
    end

    describe 'when b is not an array of multiple dimension' do
      let(:a) { described_class.new([1, 2, 3], [4, 5, 6], [7, 8, 9]) }
      let(:b) { described_class.new([2, 3, 5]) }

      it 'raises an error' do
        expect { a * b }.to raise_error(Engineering::ArrayOperationError)
      end
    end

    describe 'when a and b are arrays of multiple dimension' do
      describe 'when each item of any of the arrays (a or b) has no the same size of the other one' do
        let(:a) { described_class.new([1, 2, 3], [5, 6], [7, 8, 9]) }
        let(:b) { described_class.new([2], [3], [5]) }

        it 'raises an error' do
          expect { a * b }.to raise_error(Engineering::ArrayOperationError)
        end
      end

      describe "when amount of columns of 'a' ar diferent from amount of rows of 'b'" do
        let(:a) { described_class.new([1, 2, 3], [5, 6, 7], [7, 8, 9]) }
        let(:b) { described_class.new([2], [3]) }

        it 'raises an error' do
          expect { a * b }.to raise_error(Engineering::ArrayOperationError)
        end
      end

      describe 'when sizes are right' do
        describe "when 'a' is 1x3 and 'b' is 3x1" do
          let(:a) { described_class.new([1, 2, 3]) }
          let(:b) { described_class.new([2], [3], [5]) }
          let(:expected_result) do
            [
              [a[0][0] * b[0][0] + a[0][1] * b[1][0] + a[0][2] * b[2][0]]
            ]
          end
          let(:expected_size) do
            {
              rows: expected_result.size,
              columns: expected_result.first.size
            }
          end

          it 'returns an Engineering::Array object' do
            expect(a * b).to be_an_instance_of(described_class)
          end

          it 'returns the right array resulting on the operation' do
            expect(a * b).to match_array(expected_result)
          end

          it 'returns an array with expected dimension' do
            expect((a * b).array_size).to match(expected_size)
          end
        end

        describe "when 'a' is 3x3 and 'b' is 3x1" do
          let(:a) { described_class.new([1, 2, 3], [4, 5, 6]) }
          let(:b) { described_class.new([7, 8], [9, 10], [11, 12]) }
          let(:expected_result) do
            [
              [
                a[0][0] * b[0][0] + a[0][1] * b[1][0] + a[0][2] * b[2][0],
                a[0][0] * b[0][1] + a[0][1] * b[1][1] + a[0][2] * b[2][1]
              ],
              [
                a[1][0] * b[0][0] + a[1][1] * b[1][0] + a[1][2] * b[2][0],
                a[1][0] * b[0][1] + a[1][1] * b[1][1] + a[1][2] * b[2][1]
              ]
            ]
          end
          let(:expected_size) do
            {
              rows: expected_result.size,
              columns: expected_result.first.size
            }
          end

          it 'returns an Engineering::Array object' do
            expect(a * b).to be_an_instance_of(described_class)
          end

          it 'returns the right esulting on the operation' do
            expect(a * b).to match_array(expected_result)
          end

          it 'returns an array with expected dimension' do
            expect((a * b).array_size).to match(expected_size)
          end
        end

        describe "when 'a' is 3x3 and 'b' is 3x2" do
          let(:a) { described_class.new([1, 2, 3], [4, 5, 6], [7, 8, 9]) }
          let(:b) { described_class.new([2, 3], [3, 5], [5, 2]) }
          let(:expected_result) do
            [
              [
                a[0][0] * b[0][0] + a[0][1] * b[1][0] + a[0][2] * b[2][0],
                a[0][0] * b[0][1] + a[0][1] * b[1][1] + a[0][2] * b[2][1]
              ],
              [
                a[1][0] * b[0][0] + a[1][1] * b[1][0] + a[1][2] * b[2][0],
                a[1][0] * b[0][1] + a[1][1] * b[1][1] + a[1][2] * b[2][1]
              ],
              [
                a[2][0] * b[0][0] + a[2][1] * b[1][0] + a[2][2] * b[2][0],
                a[2][0] * b[0][1] + a[2][1] * b[1][1] + a[2][2] * b[2][1]
              ]
            ]
          end
          let(:expected_size) do
            {
              rows: expected_result.size,
              columns: expected_result.first.size
            }
          end

          it 'returns an Engineering::Array object' do
            expect(a * b).to be_an_instance_of(described_class)
          end

          it 'returns the right esulting on the operation' do
            expect(a * b).to match_array(expected_result)
          end

          it 'returns an array with expected dimension' do
            expect((a * b).array_size).to match(expected_size)
          end
        end

        describe "when 'a' is 4x4 and 'b' is 4x1" do
          let(:a) do
            described_class.new(
              [0.96593, 0.0, 0.0, 0.25882],
              [0.0, 1.0, 0.0, 0.0],
              [0.0, 0.0, 1.0, 0.0],
              [-0.25882, 0.0, 0.0, 0.96593]
            )
          end
          let(:b) { described_class.new([1.0], [1.0], [1.0], [1.0]) }
          let(:expected_result) do
            [
              [
                a[0][0] * b[0][0] + a[0][1] * b[1][0] + a[0][2] * b[2][0] + a[0][3] * b[3][0]
              ],
              [
                a[1][0] * b[0][0] + a[1][1] * b[1][0] + a[1][2] * b[2][0] + a[1][3] * b[3][0]
              ],
              [
                a[2][0] * b[0][0] + a[2][1] * b[1][0] + a[2][2] * b[2][0] + a[2][3] * b[3][0]
              ],
              [
                a[3][0] * b[0][0] + a[3][1] * b[1][0] + a[3][2] * b[2][0] + a[3][3] * b[3][0]
              ]
            ]
          end
          let(:expected_size) do
            {
              rows: expected_result.size,
              columns: expected_result.first.size
            }
          end

          it 'returns an Engineering::Array object' do
            expect(a * b).to be_an_instance_of(described_class)
          end

          it 'returns the right esulting on the operation' do
            expect(a * b).to match_array(expected_result)
          end

          it 'returns an array with expected dimension' do
            expect((a * b).array_size).to match(expected_size)
          end
        end
      end
    end
  end

  describe '#-' do
    describe "when 'a' and 'b' are of different size" do
      let(:a) { described_class.new([1, 2, 3, 4, 5, 6, 7, 8, 9]) }
      let(:b) { described_class.new([2, 3, 5]) }

      it 'raises an error' do
        expect { a - b }.to raise_error(Engineering::ArrayOperationError)
      end
    end

    describe "when 'a' and 'b' are 3x1" do
      let(:a) { described_class.new([1], [2], [5]) }
      let(:b) { described_class.new([2], [3], [3]) }
      let(:expected_result) { described_class.new([-1], [-1], [2]) }

      it 'returns an Engineering::Array object' do
        expect(a - b).to be_an_instance_of(described_class)
      end

      it 'returns right answer' do
        expect(a - b).to match_array(expected_result)
      end
    end

    describe "when 'a' and 'b' are 1x3" do
      let(:a) { described_class.new([1, 2, 5]) }
      let(:b) { described_class.new([2, 3, 3]) }
      let(:expected_result) { described_class.new([-1, -1, 2]) }

      it 'returns an Engineering::Array object' do
        expect(a - b).to be_an_instance_of(described_class)
      end

      it 'returns right answer' do
        expect(a - b).to match_array(expected_result)
      end
    end
  end

  describe '#x' do
    describe "when 'a' and 'b' are of different size" do
      let(:a) { described_class.new([1, 2, 3, 4, 5, 6, 7, 8, 9]) }
      let(:b) { described_class.new([2, 3, 5]) }

      it 'raises an error' do
        expect { a + b }.to raise_error(Engineering::ArrayOperationError)
      end
    end

    describe "when 'a' and 'b' are 3x1" do
      let(:a) { described_class.new([1], [2], [5]) }
      let(:b) { described_class.new([2], [3], [3]) }
      let(:expected_result) { described_class.new([3], [5], [8]) }

      it 'returns an Engineering::Array object' do
        expect(a + b).to be_an_instance_of(described_class)
      end

      it 'returns right answer' do
        expect(a + b).to match_array(expected_result)
      end
    end

    describe "when 'a' and 'b' are 1x3" do
      let(:a) { described_class.new([1, 2, 5]) }
      let(:b) { described_class.new([2, 3, 3]) }
      let(:expected_result) { described_class.new([3, 5, 8]) }

      it 'returns an Engineering::Array object' do
        expect(a + b).to be_an_instance_of(described_class)
      end

      it 'returns right answer' do
        expect(a + b).to match_array(expected_result)
      end
    end

    describe "when 'a' and 'b' are 3x3" do
      let(:a) { described_class.new([1, 2, 5], [1, 2, 5], [3, 1, 5]) }
      let(:b) { described_class.new([2, 3, 3], [-2, -3, -3], [3, -1, 5]) }
      let(:expected_result) { described_class.new([3, 5, 8], [-1, -1, 2], [6, 0, 10]) }

      it 'returns an Engineering::Array object' do
        expect(a + b).to be_an_instance_of(described_class)
      end

      it 'returns right answer' do
        expect(a + b).to match_array(expected_result)
      end
    end
  end
end
