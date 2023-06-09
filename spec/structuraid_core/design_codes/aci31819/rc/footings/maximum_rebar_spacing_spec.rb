require 'spec_helper'

RSpec.describe StructuraidCore::DesignCodes::Aci31819::Rc::Footings::MaximumRebarSpacing do
  describe '.call' do
    subject(:result) do
      described_class.call(
        support_type:,
        footing_height:,
        for_min_rebar:,
        yield_stress:,
        reinforcement_cover:
      )
    end

    let(:support_type) { :over_soil }
    let(:footing_height) { 100 }
    let(:for_min_rebar) { false }
    let(:yield_stress) { 420 }
    let(:reinforcement_cover) { 75 }

    it 'returns the max spacing' do
      expect(result).to be_between(150, 310)
    end

    describe 'when support type is invalid' do
      let(:support_type) { :invalid }

      it 'raises an error' do
        expect { result }.to raise_error(StructuraidCore::Errors::DesignCodes::UnrecognizedValueError)
      end
    end

    describe 'when is for min rebar' do
      let(:for_min_rebar) { true }

      it 'returns the max spacing' do
        expect(result).to be_between([450, 3 * footing_height].min, [450, 3 * footing_height].max)
      end
    end
  end
end
