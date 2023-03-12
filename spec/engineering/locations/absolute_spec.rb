require 'spec_helper'
require 'engineering/locations/absolute'
require 'engineering/array'

RSpec.describe Engineering::Locations::Absolute do
  subject(:relative) { described_class.new(value_x:, value_y:, value_z:) }

  let(:value_x) { 3.0 }
  let(:value_y) { 4.0 }
  let(:value_z) { 6.0 }

  describe '#to_a' do
    it 'returns an Engineering::Array' do
      expect(relative.to_a).to be_an_instance_of(Engineering::Array)
    end

    it 'returns right values' do
      expect(relative.to_a).to match_array([[value_x], [value_y], [value_z]])
    end
  end
end
