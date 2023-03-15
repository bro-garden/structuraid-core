require 'spec_helper'
require 'matrix'

RSpec.describe StructuraidCore::Engineering::Locations::Absolute do
  subject(:absolute) { described_class.new(value_x:, value_y:, value_z:) }

  let(:value_x) { 3.0 }
  let(:value_y) { 4.0 }
  let(:value_z) { 6.0 }

  describe '#to_matrix' do
    it 'returns a Matrix object' do
      expect(absolute.to_matrix).to be_an_instance_of(Matrix)
    end

    it 'returns right values' do
      expect(absolute.to_matrix.to_a).to match_array([[value_x], [value_y], [value_z]])
    end
  end
end
