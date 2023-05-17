require 'spec_helper'

RSpec.describe StructuraidCore::DesignCodes::Nsr10::Rc::Footings::MinHeight do
  describe '.call' do
    subject(:result) do
      described_class.call(
        bottom_rebar_effective_height:,
        support_type:
      )
    end

    let(:bottom_rebar_effective_height) { 250 }
    let(:support_type) { :over_soil }

    it 'returns true' do
      expect(result).to eq(true)
    end

    describe 'when the effective height of bottom rebar is too low' do
      let(:bottom_rebar_effective_height) { 100 }

      it 'raises an error' do
        expect { result }.to raise_error(StructuraidCore::Errors::DesignCodes::RequirementNotFulfilledError)
      end
    end

    describe 'when support type is over piles' do
      let(:support_type) { :over_piles }

      it 'raises an error' do
        expect { result }.to raise_error(StructuraidCore::Errors::DesignCodes::RequirementNotFulfilledError)
      end

      describe 'when footing is tall enough' do
        let(:bottom_rebar_effective_height) { 350 }

        it 'returns true' do
          expect(result).to eq(true)
        end
      end
    end
  end
end
