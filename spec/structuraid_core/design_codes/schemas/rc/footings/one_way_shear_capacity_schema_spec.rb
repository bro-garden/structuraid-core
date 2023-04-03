require 'spec_helper'

RSpec.describe StructuraidCore::DesignCodes::Schemas::RC::Footings::OneWayShearCapacitySchema do
  describe '.validate!' do
    subject(:result) { described_class.validate!(params) }

    let(:params) do
      {
        design_compression_strength: 28,
        width: 2500,
        effective_height: 450,
        light_concrete_modification_factor: 1
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
        design_compression_strength: 28,
        width: 2500,
        effective_height: 450,
        light_concrete_modification_factor: 1
      }
    end

    # rubocop:disable RSpec/ExampleLength
    it 'returns a struct with the required param' do
      expect(result.members).to match_array(
        %i[
          design_compression_strength
          width
          effective_height
          light_concrete_modification_factor
          schema
        ]
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end
end
