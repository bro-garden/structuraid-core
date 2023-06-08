require 'spec_helper'

RSpec.describe StructuraidCore::DesignCodes::Nsr10::Rc::Footings::BendingReinforcementRatio do
  describe '.call' do
    subject(:result) do
      described_class.call(
        design_compression_strength:,
        design_steel_yield_strength:,
        width:,
        effective_height:,
        flexural_moment:,
        capacity_reduction_factor:
      )
    end

    let(:design_steel_yield_strength) { 420 } # N/(mm**2)
    let(:width) { 2_500 } # mm
    let(:effective_height) { 450 } # mm
    let(:capacity_reduction_factor) { 0.90 }
    let(:min_ratio) do
      StructuraidCore::DesignCodes::Nsr10::Rc::Footings::BendingReinforcementRatio::MINIMUM_RATIO
    end

    describe 'when concrete is 28MPa' do
      let(:design_compression_strength) { 28 } # N/(mm**2)

      describe 'when flexural moment is small' do
        let(:flexural_moment) { 50 } # N*mm

        it 'returns minimal ratio' do
          expect(result.computed_ratio <= 0.0025).to eq(true)
        end

        it "returns true at 'is_minimum_ratio' strcut attribute" do
          expect(result.is_minimum_ratio).to eq(true)
        end
      end

      describe 'when flexural moment is 2348493750 N*mm' do
        let(:flexural_moment) { 2_348_493_750 }
        let(:expected_ratio) { 0.0140 }

        it 'returns right ratio' do
          expect(result.computed_ratio.round(4)).to eq(expected_ratio)
        end

        it "eturns false at 'is_minimum_ratio' strcut attribute" do
          expect(result.is_minimum_ratio).to eq(false)
        end
      end

      describe 'when flexural moment is 713306250 N*mm' do
        let(:flexural_moment) { 713_306_250 }
        let(:expected_ratio) { 0.0039 }

        it 'returns right ratio' do
          expect(result.computed_ratio.round(4)).to eq(expected_ratio)
        end

        it "eturns false at 'is_minimum_ratio' strcut attribute" do
          expect(result.is_minimum_ratio).to eq(false)
        end
      end

      describe 'when flexural moment is too hight' do
        let(:flexural_moment) { 999_999_999_999_999 }

        it 'raises an error' do
          expect { result }.to raise_error(StructuraidCore::Errors::DesignCodes::RequirementNotFulfilledError)
        end
      end
    end

    describe 'when concrete is 42MPa' do
      let(:design_compression_strength) { 42 } # N/(mm**2)

      describe 'when flexural moment is small' do
        let(:flexural_moment) { 50 } # N*m

        it 'returns minimal ratio' do
          expect(result.computed_ratio <= 0.0025).to eq(true)
        end

        it "returns true at 'is_minimum_ratio' strcut attribute" do
          expect(result.is_minimum_ratio).to eq(true)
        end
      end

      describe 'when flexural moment is 3558431250 N*mm' do
        let(:flexural_moment) { 3_558_431_250 }
        let(:expected_ratio) { 0.0213 }

        it 'returns right ratio' do
          expect(result.computed_ratio.round(4)).to eq(expected_ratio)
        end

        it "eturns false at 'is_minimum_ratio' strcut attribute" do
          expect(result.is_minimum_ratio).to eq(false)
        end
      end

      describe 'when flexural moment is 1107675000 N*mm' do
        let(:flexural_moment) { 1_107_675_000 }
        let(:expected_ratio) { 0.0060 }

        it 'returns right ratio' do
          expect(result.computed_ratio.round(4)).to eq(expected_ratio)
        end

        it "eturns false at 'is_minimum_ratio' strcut attribute" do
          expect(result.is_minimum_ratio).to eq(false)
        end
      end

      describe 'when flexural moment is too hight' do
        let(:flexural_moment) { 999_999_999_999_999 }

        it 'raises an error' do
          expect { result }.to raise_error(StructuraidCore::Errors::DesignCodes::RequirementNotFulfilledError)
        end
      end
    end
  end
end
