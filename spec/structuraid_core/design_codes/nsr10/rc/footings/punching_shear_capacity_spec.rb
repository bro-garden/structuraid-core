require 'spec_helper'

RSpec.describe StructuraidCore::DesignCodes::Nsr10::Rc::Footings::PunchingShearCapacity do
  describe '.call' do
    subject(:result) do
      described_class.call(
        column_section_width:,
        column_section_height:,
        design_compression_strength:,
        critical_section_perimeter:,
        effective_height:,
        light_concrete_modification_factor:,
        column_location:
      )
    end

    let(:column_section_width) { 500 }
    let(:column_section_height) { 500 }
    let(:design_compression_strength) { 28 }
    let(:critical_section_perimeter) { 1480 }
    let(:effective_height) { 120 }
    let(:light_concrete_modification_factor) { 1 }
    let(:column_location) { :interior }

    it 'returns the shear capacity for punching failure' do
      expect(result.round(2)).to eq(310_124.39)
    end

    describe 'when column is located in the footing corner' do
      let(:column_location) { :corner }

      it 'returns the shear capacity for punching failure' do
        expect(result.round(2)).to eq(282_490.04)
      end
    end

    describe 'when column has a very high aspect ratio' do
      let(:column_section_width) { 700 }
      let(:column_section_height) { 200 }

      it 'returns the shear capacity for punching failure' do
        expect(result.round(2)).to eq(251_053.07)
      end
    end
  end
end
