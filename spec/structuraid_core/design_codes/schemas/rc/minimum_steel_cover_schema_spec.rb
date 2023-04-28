require 'spec_helper'

RSpec.describe StructuraidCore::DesignCodes::Schemas::RC::MinimumSteelCoverSchema do
  describe '.validate!' do
    subject(:result) { described_class.validate!(params) }

    let(:params) { { concrete_casting_against_soil: true, environment_exposure: false } }

    it 'returns true' do
      expect(result).to eq(true)
    end

    describe 'when required param is missing' do
      let(:params) { {} }

      it 'raises an error' do
        expect { result }.to raise_error(StructuraidCore::DesignCodes::MissingParamError)
      end
    end

    describe 'when enum param has invalid value' do
      let(:params) do
        {
          concrete_casting_against_soil: true,
          environment_exposure: false,
          structural_element: :something_crazy
        }
      end

      it 'raises an error' do
        expect { result }.to raise_error(StructuraidCore::DesignCodes::UnrecognizedValueError)
      end
    end
  end

  describe '.structurize' do
    subject(:result) { described_class.structurize(params) }

    let(:params) { { concrete_casting_against_soil: true, environment_exposure: false } }

    it 'returns a struct with the required param' do
      expect(result.concrete_casting_against_soil).to eq(true)
    end
  end
end
