require 'spec_helper'
require 'elements/reinforcement/straight_longitudinal_layer'
require 'engineering/locations/relative'
require 'elements/reinforcement/rebar'
require 'materials/steel'

RSpec.describe Elements::Reinforcement::StraightLongitudinalLayer do
  subject(:reinforcement) do
    described_class.new(
      start_location:,
      end_location:,
      number_of_rebars:,
      rebar:,
      id: 1,
      distribution_direction: :length_1
    )
  end

  let(:start_location) { Engineering::Locations::Relative.new(value_1: -950, value_2: -450, value_3: 0) }
  let(:end_location) { Engineering::Locations::Relative.new(value_1: 950, value_2: 450, value_3: 0) }
  let(:material) { Materials::Steel.new(yield_stress: 4200) }
  let(:number_of_rebars) { 5 }
  let(:rebar) do
    Elements::Reinforcement::Rebar.new(
      number: 3,
      material:
    )
  end

  describe '#area' do
    it 'returns the area of the layer' do
      expect(reinforcement.area).to eq(number_of_rebars * rebar.area)
    end
  end

  describe '#diameter' do
    it 'returns the diameter of the layer' do
      expect(reinforcement.diameter).to eq(rebar.diameter)
    end
  end

  describe '#length' do
    let(:expected_length) { 900 }

    it 'returns the length of the layer' do
      expect(reinforcement.length).to eq(expected_length)
    end
  end
end
