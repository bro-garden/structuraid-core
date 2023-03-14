require 'spec_helper'

# rubocop:disable RSpec/FilePath
RSpec.describe StructuraidCore::DesignCodes::NSR10::RC::ElasticModulus do
  describe '.call' do
    subject(:result) { described_class.call(design_compression_strength:) }

    let(:design_compression_strength) { 28 }

    it 'returns the elastic module' do
      expect(result.round).to eq(24_870)
    end

    describe 'when compression strength is not passed' do
      let(:design_compression_strength) { nil }

      it 'raises an error' do
        expect { result }.to raise_error(StructuraidCore::DesignCodes::MissingParamError)
      end
    end
  end
end
# rubocop:enable RSpec/FilePath
