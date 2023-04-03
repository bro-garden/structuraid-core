require 'spec_helper'

RSpec.describe StructuraidCore::DesignCodes::Schemas::RC::ReductionFactorSchema do
  describe '.validate!' do
    subject(:result) { described_class.validate!(params) }

    let(:params) do
      {
        strength_controlling_behaviour: :compression_controlled
      }
    end

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

    let(:params) do
      {
        strength_controlling_behaviour: :compression_controlled
      }
    end

    # rubocop:disable RSpec/ExampleLength
    it 'returns a struct with the required param' do
      expect(result.members).to match_array(
        %i[
          strength_controlling_behaviour
          strain
          is_coil_rebar
          schema
        ]
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end
end
