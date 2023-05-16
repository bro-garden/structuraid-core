require 'spec_helper'

RSpec.describe StructuraidCore::Designers::Footings::CentricIsolated do
  describe '.call' do
    subject(:context) do
      described_class.call(
        footing: build(:footing),
        load_scenario:,
        soil: build(:soil),
        design_code: StructuraidCore::DesignCodes::NSR10,
        steel: build(:steel)
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

    before do
      allow(StructuraidCore::Designers::Footings::Steps::ResolveDesignCode).to receive(:call!)
      allow(StructuraidCore::Designers::Footings::Steps::CheckBearingCapacity).to receive(:call!)
      allow(StructuraidCore::Designers::Footings::Steps::AssignAnalysisDirection).to receive(:call!)
      allow(StructuraidCore::Designers::Footings::Steps::CentricIsolated::ComputeRequiredRebarRatio).to receive(:call!)

      context
    end

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it { expect(StructuraidCore::Designers::Footings::Steps::ResolveDesignCode).to have_received(:call!) }
    it { expect(StructuraidCore::Designers::Footings::Steps::CheckBearingCapacity).to have_received(:call!) }
    it { expect(StructuraidCore::Designers::Footings::Steps::AssignAnalysisDirection).to have_received(:call!) }

    it do
      expect(
        StructuraidCore::Designers::Footings::Steps::CentricIsolated::ComputeRequiredRebarRatio
      ).to have_received(:call!)
    end
  end
end
