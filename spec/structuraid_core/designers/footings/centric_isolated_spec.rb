require 'spec_helper'

RSpec.describe StructuraidCore::Designers::Footings::CentricIsolated do
  describe '.call' do
    subject(:context) do
      described_class.call(
        footing:,
        load_scenario:,
        soil:,
        design_code:
      )
    end

    let(:footing) do
      StructuraidCore::Elements::Footing.new(
        length_1: 1500,
        length_2: 1500,
        height: 500,
        material: StructuraidCore::Materials::Concrete.new(
          elastic_module: 1800,
          design_compression_strength: 28,
          specific_weight: 0.00002352
        ),
        cover_lateral: 50,
        cover_top: 50,
        cover_bottom: 75
      )
    end

    let(:load_scenario) do
      StructuraidCore::Loads::Scenarios::Footings::CentricIsolated.new(
        service_load: StructuraidCore::Loads::PointLoad.new(
          value: -112_500,
          location: StructuraidCore::Engineering::Locations::Absolute.new(
            value_x: 0,
            value_y: 0,
            value_z: 0
          ),
          label: 'Service Load'
        ),
        ultimate_load: StructuraidCore::Loads::PointLoad.new(
          value: -152_500,
          location: StructuraidCore::Engineering::Locations::Absolute.new(
            value_x: 0,
            value_y: 0,
            value_z: 0
          ),
          label: 'Service Load'
        )
      )
    end

    let(:soil) { StructuraidCore::Materials::Soil.new(bearing_capacity: 0.065) }

    let(:design_code) { 'nsr_10' }

    before do
      allow(StructuraidCore::Designers::Footings::Steps::ResolveDesignCode).to receive(:call)
      allow(StructuraidCore::Designers::Footings::Steps::CheckBearingCapacity).to receive(:call)

      context
    end

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'calls the interactors' do
      expect(StructuraidCore::Designers::Footings::Steps::ResolveDesignCode).to have_received(:call)
      expect(StructuraidCore::Designers::Footings::Steps::CheckBearingCapacity).to have_received(:call)
    end
  end
end
