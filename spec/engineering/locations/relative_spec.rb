require 'spec_helper'
require 'engineering/locations/relative'
require 'engineering/locations/absolute'
require 'matrix'
require 'engineering/vector'

RSpec.describe Engineering::Locations::Relative do
  subject(:relative) { described_class.new(value_1:, value_2:, value_3:) }

  let(:value_1) { 3.0 }
  let(:value_2) { 4.0 }
  let(:value_3) { 6.0 }

  describe '#to_matrix' do
    it 'returns an Matrix object' do
      expect(relative.to_matrix).to be_an_instance_of(Matrix)
    end

    it 'returns right module' do
      expect(relative.to_matrix.to_a).to match_array([[value_1], [value_2], [value_3]])
    end
  end

  describe '#to_vector' do
    it 'returns an Engineering::Vector' do
      expect(relative.to_vector).to be_an_instance_of(Engineering::Vector)
    end

    it 'returns a vector with same components values as the relative location components' do
      expect(relative.to_vector.to_matrix.to_a).to match_array(relative.to_matrix.to_a)
    end
  end

  describe '.from_matrix' do
    let(:from_matrix) { described_class.from_matrix(matrix:) }

    let(:matrix) { Matrix.column_vector([value_1, value_2, value_3]) }

    it 'returns an Engineering::Locations::Relative' do
      expect(from_matrix).to be_an_instance_of(described_class)
    end

    it 'returns a relative location with same components values as the matrix components' do
      expect(from_matrix.to_matrix.to_a).to match_array(matrix.to_a)
    end
  end
end
