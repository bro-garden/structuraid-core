require 'spec_helper'

RSpec.describe StructuraidCore::Designers::Footings::Steps::CheckBearingCapacity do
  let(:footing) do
    build(
      :footing,
      length_1: 1500,
      length_2: 1500,
      height: 500,
      material: build(:concrete)
    )
  end

  let(:load_location) { build(:absolute_location) }

  let(:load_scenario) do
    build(
      :loads_scenarios_centric_isolated,
      service_load: build(:point_load, value: -112_500, location: load_location),
      ultimate_load: build(:point_load, value: -152_500, location: load_location)
    )
  end

  describe '.call' do
    subject(:result) do
      described_class.call(
        footing:,
        load_scenario:,
        soil:
      )
    end

    describe 'when soil bearing capacity is exceeded' do
      let(:soil) { build(:soil, bearing_capacity: 0.04) }

      it 'fails' do
        expect(result.success?).to be(false)
      end

      it 'returns a message' do
        expect(result.message).to match('Soil bearing capacity exceeded')
      end
    end

    describe 'when soil bearing capacity is not exceeded' do
      let(:soil) { build(:soil, bearing_capacity: 0.065) }

      it 'succeeds' do
        expect(result.success?).to be(true)
      end
    end
  end
end
