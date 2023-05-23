require 'spec_helper'

RSpec.describe StructuraidCore::DesignCodes::Schemas::Rc::ElasticModulusSchema do
  describe '.validate!' do
    subject(:result) { described_class.validate!(params) }

    let(:params) { { design_compression_strength: 28 } }

    it 'returns true' do
      expect(result).to eq(true)
    end

    describe 'when required param is missing' do
      let(:params) { {} }

      it 'raises an error' do
        expect { result }.to raise_error(StructuraidCore::Errors::DesignCodes::MissingParamError)
      end
    end
  end

  describe '.structurize' do
    subject(:result) { described_class.structurize(params) }

    let(:params) { { design_compression_strength: 28 } }

    it 'returns a struct with the required param' do
      expect(result.design_compression_strength).to eq(28)
    end
  end
end
