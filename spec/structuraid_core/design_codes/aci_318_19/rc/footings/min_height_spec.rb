require 'spec_helper'

# rubocop:disable RSpec/FilePath
RSpec.describe StructuraidCore::DesignCodes::ACI31819::RC::Footings::MinHeight do
  describe '.call' do
    subject(:result) do
      described_class.call(
        bottom_rebar_effective_height:
      )
    end

    let(:bottom_rebar_effective_height) { 250 }

    it 'returns true' do
      expect(result).to eq(true)
    end

    describe 'when the effective height of bottom rebar is too low' do
      let(:bottom_rebar_effective_height) { 100 }

      it 'raises an error' do
        expect { result }.to raise_error(StructuraidCore::DesignCodes::RequirementNotFulfilledError)
      end
    end
  end
end
# rubocop:enable RSpec/FilePath
