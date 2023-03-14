require 'spec_helper'

RSpec.describe StructuraidCore::Engineering::Vector do
  let(:value_x) { 3.0 }
  let(:value_y) { 4.0 }
  let(:value_z) { 0.0 }

  describe '#magnitude' do
    subject(:vector) { described_class.new(value_x:, value_y:, value_z:) }

    let(:expected_magnitude) { Math.sqrt(value_x**2 + value_y**2 + value_z**2) }

    it 'returns right magnitude' do
      expect(vector.magnitude).to be(expected_magnitude)
    end
  end

  describe '#direction' do
    subject(:vector) { described_class.new(value_x:, value_y:, value_z:) }

    let(:expected_unit_vector) do
      vector_magnitude = vector.magnitude

      [
        value_x / vector_magnitude,
        value_y / vector_magnitude,
        value_z / vector_magnitude
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

    let(:value) { Math.sqrt(value_x**2 + value_y**2 + value_z**2) }
    let(:direction) do
      [
        value_x / value,
        value_y / value,
        value_z / value
      ]
    end

    it 'returns an instance of described class' do
      expect(vector).to be_an_instance_of(described_class)
    end

    it 'sets right value_x' do
      expect(vector.value_x).to be(value_x)
    end

    it 'sets right value_y' do
      expect(vector.value_y).to be(value_y)
    end

    it 'sets right value_z' do
      expect(vector.value_z).to be(value_z)
    end
  end
end
