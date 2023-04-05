require 'spec_helper'

RSpec.describe StructuraidCore::DesignCodes::Schemas::RC::Footings::PunchingCriticalSectionPerimeterSchema do
  let(:length_1) { 2500 }
  let(:length_2) { 1000 }
  let(:height) { 300 }
  let(:cover_lateral) { 50 }
  let(:cover_top) { 50 }
  let(:cover_bottom) { 75 }
  let(:section_direction) { :length_1 }

  let(:footing) do
    StructuraidCore::Elements::Footing.new(
      length_1:,
      length_2:,
      height:,
      material: StructuraidCore::Materials::Concrete.new(
        elastic_module: 1800,
        design_compression_strength: 28,
        specific_weight: 2.4
      ),
      cover_lateral:,
      cover_top:,
      cover_bottom:,
      longitudinal_bottom_reinforcement_length_1: nil,
      longitudinal_bottom_reinforcement_length_2: nil
    )
  end

  let(:lcs) do
    StructuraidCore::Engineering::Locations::CoordinatesSystem.new(
      anchor_location: StructuraidCore::Engineering::Locations::Absolute.new(
        value_x: 0,
        value_y: 0,
        value_z: 0
      )
    )
  end

  describe '.validate!' do
    subject(:result) { described_class.validate!(params) }

    let(:params) do
      {
        column_section_length_1: 450,
        column_section_length_2: 250,
        column_absolute_location: StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: -1025,
          value_y: 375,
          value_z: 0
        ),
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
        column_absolute_location: StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: -1025,
          value_y: 375,
          value_z: 0
        ),
        footing:
      }
    end

    # rubocop:disable RSpec/ExampleLength
    it 'returns a struct with the required param' do
      expect(result.members).to match_array(
        %i[
          column_section_length_1
          column_section_length_2
          column_absolute_location
          footing
          schema
        ]
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end
end
