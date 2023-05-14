require 'spec_helper'

RSpec.describe StructuraidCore::Designers::Footings::Steps::CheckBearingCapacity do
  let(:footing) do
    StructuraidCore::Elements::Footing.new(
      length_1:,
      length_2:,
      height:,
      material: concrete,
      cover_lateral:,
      cover_top:,
      cover_bottom:
    )
  end

  let(:length_1) { 1500 }
  let(:length_2) { 1500 }
  let(:height) { 500 }
  let(:cover_lateral) { 50 }
  let(:cover_top) { 50 }
  let(:cover_bottom) { 75 }

  let(:concrete) do
    StructuraidCore::Materials::Concrete.new(
      elastic_module: 1800,
      design_compression_strength: 28,
      specific_weight: 0.00002352
    )
  end

  let(:load_location) do
    StructuraidCore::Engineering::Locations::Absolute.new(
      value_x: 0,
      value_y: 0,
      value_z: 0
    )
  end

  let(:load_scenario) do
    StructuraidCore::Loads::Scenarios::Footings::CentricIsolated.new(
      service_load: StructuraidCore::Loads::PointLoad.new(
        value: -112500,
        location: load_location,
        label: 'Service Load'
      ),
      ultimate_load: StructuraidCore::Loads::PointLoad.new(
        value: -152500,
        location: load_location,
        label: 'Service Load'
      )
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
      let(:soil) { StructuraidCore::Materials::Soil.new(bearing_capacity: 0.04) }

      it 'fails' do
        expect(result.success?).to be(false)
      end

      it 'returns a message' do
        expect(result.message).to eq('Soil bearing capacity exceeded. 0.06176 > 0.04')
      end
    end

    describe 'when soil bearing capacity is not exceeded' do
      let(:soil) { StructuraidCore::Materials::Soil.new(bearing_capacity: 0.065) }

      it 'succeeds' do
        expect(result.success?).to be(true)
      end
    end
  end
end
