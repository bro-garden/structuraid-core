require 'spec_helper'
require 'engineering/vector'

RSpec.describe Engineering::Vector do
  subject(:vector) { described_class.new(value_x:, value_y:, value_z:) }

  let(:value_x) { 3 }
  let(:value_y) { 4 }
  let(:value_z) { 0 }
  let(:expected_magnitude) { Math.sqrt(value_x**2 + value_y**2 + value_z**2) }

  describe '#magnitude' do
    it 'returns right magnitude' do
      expect(vector.magnitude).to be(expected_magnitude)
    end
  end

  describe '#direction' do
    let(:expected_module) do
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
      expect(vector.direction).to eq(expected_module)
    end
  end
end
