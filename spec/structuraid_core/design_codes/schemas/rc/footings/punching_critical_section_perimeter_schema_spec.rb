require 'spec_helper'

RSpec.describe StructuraidCore::DesignCodes::Schemas::RC::Footings::PunchingCriticalSectionPerimeterSchema do
  let(:footing) { build(:footing) }

  describe '.validate!' do
    subject(:result) { described_class.validate!(params) }

    let(:params) do
      {
        column_section_length_1: 450,
        column_section_length_2: 250,
        column_absolute_location: build(:absolute_location, value_x: -1025, value_y: 375, value_z: 0),
        column_label: :column,
        footing:
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
        column_section_length_1: 450,
        column_section_length_2: 250,
        column_absolute_location: build(:absolute_location, value_x: -1025, value_y: 375, value_z: 0),
        column_label: :column,
        footing:
      }
    end

    let(:expected_params) do
      %i[
        column_section_length_1
        column_section_length_2
        column_absolute_location
        column_label
        footing
        schema
      ]
    end

    it 'returns a struct with the required param' do
      expect(result.members).to match_array(expected_params)
    end
  end
end
