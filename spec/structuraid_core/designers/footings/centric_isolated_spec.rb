require 'spec_helper'

RSpec.describe StructuraidCore::Designers::Footings::CentricIsolated do
  describe '.call' do
    subject(:context) do
      described_class.call(
        footing: build(:footing, :with_reinforcement),
        load_scenario: build(:loads_scenarios_centric_isolated),
        soil: build(:soil),
        design_code: StructuraidCore::DesignCodes::Nsr10,
        steel: build(:steel)
      )
    end

    before do
      allow(StructuraidCore::Designers::Footings::Steps::ResolveDesignCode).to receive(:call!)
      allow(StructuraidCore::Designers::Footings::Steps::CheckBearingCapacity).to receive(:call!)
      allow(StructuraidCore::Designers::Footings::Steps::AssignAnalysisDirection).to receive(:call!)
      allow(StructuraidCore::Designers::Footings::Steps::CentricIsolated::ComputeRequiredRebarRatio).to receive(:call!)
      allow(
        StructuraidCore::Designers::Footings::Steps::CentricIsolated::SetReinforcementLayersCoordinatesToFooting
      ).to receive(:call!)
      allow(
        StructuraidCore::Designers::Footings::Steps::CentricIsolated::SetInitialLongitudinalReinforcement
      ).to receive(:call!)
      allow(StructuraidCore::Designers::Footings::Steps::CheckMinHeight).to receive(:call!)

      context
    end

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it { expect(StructuraidCore::Designers::Footings::Steps::ResolveDesignCode).to have_received(:call!) }
    it { expect(StructuraidCore::Designers::Footings::Steps::CheckBearingCapacity).to have_received(:call!) }
    it { expect(StructuraidCore::Designers::Footings::Steps::AssignAnalysisDirection).to have_received(:call!) }
    it { expect(StructuraidCore::Designers::Footings::Steps::CheckMinHeight).to have_received(:call!) }

    it do
      expect(
        StructuraidCore::Designers::Footings::Steps::CentricIsolated::SetInitialLongitudinalReinforcement
      ).to have_received(:call!)
    end

    it do
      expect(
        StructuraidCore::Designers::Footings::Steps::CentricIsolated::SetReinforcementLayersCoordinatesToFooting
      ).to have_received(:call!)
    end

    it do
      expect(
        StructuraidCore::Designers::Footings::Steps::CentricIsolated::ComputeRequiredRebarRatio
      ).to have_received(:call!)
    end
  end
end
