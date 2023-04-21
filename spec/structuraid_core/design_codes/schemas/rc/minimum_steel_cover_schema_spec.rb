require 'spec_helper'

RSpec.describe StructuraidCore::DesignCodes::Schemas::RC::MinimumSteelCoverSchema do
  describe '.validate!' do
    subject(:result) { described_class.validate!(params) }

    let(:params) { { concrete_casting_or_exposision_case: 'c.7.7.1.a' } }

    it 'returns true' do
      expect(result).to eq(true)
    end

    describe 'when required param is missing' do
      let(:params) { {} }

      it 'raises an error' do
        expect { result }.to raise_error(StructuraidCore::DesignCodes::MissingParamError)
      end
    end
  end

  describe '.structurize' do
    subject(:result) { described_class.structurize(params) }

    let(:params) { { concrete_casting_or_exposision_case: 'c.7.7.1.b' } }

    it 'returns a struct with the required param' do
      expect(result.concrete_casting_or_exposision_case).to eq('c.7.7.1.b')
    end
  end
end
