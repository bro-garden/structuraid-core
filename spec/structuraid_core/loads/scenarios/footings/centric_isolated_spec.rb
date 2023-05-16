require 'spec_helper'

RSpec.describe StructuraidCore::Loads::Scenarios::Footings::CentricIsolated do
  subject(:scenario) { described_class.new(ultimate_load:, service_load:) }

  let(:ultimate_load) do
    StructuraidCore::Loads::PointLoad.new(
      value: -40_000,
      location: StructuraidCore::Engineering::Locations::Absolute.new(
        value_x: 1000,
        value_y: 4000,
        value_z: 0
      ),
      label: 'column_1'
    )
  end

  let(:service_load) do
    StructuraidCore::Loads::PointLoad.new(
      value: -30_000,
      location: StructuraidCore::Engineering::Locations::Absolute.new(
        value_x: 1000,
        value_y: 4000,
        value_z: 0
      ),
      label: 'column_1'
    )
  end

  describe '#total_service_load' do
    subject(:total_service_load) { scenario.total_service_load }

    it 'returns the service load' do
      expect(total_service_load.value).to eq(-30_000)
    end
  end

  describe '#total_ultimate_load' do
    subject(:total_ultimate_load) { scenario.total_ultimate_load }

    it 'returns the ultimate load' do
      expect(total_ultimate_load.value).to eq(-40_000)
    end
  end
end
