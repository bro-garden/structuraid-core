require 'spec_helper'
require 'engineering/vector'

RSpec.describe Engineering::Vector do
  let(:value_i) { 3.0 }
  let(:value_j) { 4.0 }
  let(:value_k) { 0.0 }

  describe '#magnitude' do
    subject(:vector) { described_class.new(value_i:, value_j:, value_k:) }

    let(:expected_magnitude) { Math.sqrt(value_i**2 + value_j**2 + value_k**2) }

    it 'returns right magnitude' do
      expect(vector.magnitude).to be(expected_magnitude)
    end
  end

  describe '#direction' do
    subject(:vector) { described_class.new(value_i:, value_j:, value_k:) }

    let(:expected_unit_vector) do
      vector_magnitude = vector.magnitude

      [
        value_i / vector_magnitude,
        value_j / vector_magnitude,
        value_k / vector_magnitude
      ]
    end

    it 'returns an array' do
      expect(vector.direction).to be_a(Array)
    end

    it 'returns right module' do
      expect(vector.direction).to eq(expected_unit_vector)
    end
  end

  describe '.with_value' do
    subject(:vector) { described_class.with_value(value:, direction:) }

    let(:value) { Math.sqrt(value_i**2 + value_j**2 + value_k**2) }
    let(:direction) do
      [
        value_i / value,
        value_j / value,
        value_k / value
      ]
    end

    it 'returns an instance of described class' do
      expect(vector).to be_an_instance_of(described_class)
    end

    it 'sets right value_i' do
      expect(vector.value_i).to be(value_i)
    end

    it 'sets right value_j' do
      expect(vector.value_j).to be(value_j)
    end

    it 'sets right value_k' do
      expect(vector.value_k).to be(value_k)
    end
  end
end
