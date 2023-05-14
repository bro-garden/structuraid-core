require 'spec_helper'

RSpec.describe StructuraidCore::Loads::Scenarios::Footings::CentricCombinedTwoColumns do
  subject(:scenario) { described_class.new(ultimate_loads:, service_loads:) }

  let(:ultimate_loads) do
    [
      StructuraidCore::Loads::PointLoad.new(
        value: -40_000,
        location: StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 1000,
          value_y: 4000,
          value_z: 0
        ),
        label: 'column_1'
      ),
      StructuraidCore::Loads::PointLoad.new(
        value: -10_000,
        location: StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 1000,
          value_y: -1000,
          value_z: 0
        ),
        label: 'column_2'
      )
    ]
  end

  let(:service_loads) do
    [
      StructuraidCore::Loads::PointLoad.new(
        value: -30_000,
        location: StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 1000,
          value_y: 4000,
          value_z: 0
        ),
        label: 'column_1'
      ),
      StructuraidCore::Loads::PointLoad.new(
        value: -8_000,
        location: StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 1000,
          value_y: -1000,
          value_z: 0
        ),
        label: 'column_2'
      )
    ]
  end

  describe '#total_service_load' do
    subject(:total_service_load) { scenario.total_service_load }

    it 'returns the sum of the service loads' do
      expect(total_service_load).to eq(-38_000)
    end
  end

  describe '#total_ultimate_load' do
    subject(:total_ultimate_load) { scenario.total_ultimate_load }

    it 'returns the sum of the ultimate loads' do
      expect(total_ultimate_load).to eq(-50_000)
    end
  end
end
