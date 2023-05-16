require 'spec_helper'

RSpec.describe StructuraidCore::Designers::Footings::Steps::CentricIsolated::ComputeRequiredRebarRatio do
  describe '.call' do
    subject(:result) do
      described_class.call(footing:, load_scenario:, analysis_direction:, design_code:, steel: build(:steel))
    end

    let(:footing) do
      StructuraidCore::Elements::Footing.new(
        length_1: 1500,
        length_2: 1500,
        height:,
        material: StructuraidCore::Materials::Concrete.new(
          elastic_module: 1800,
          design_compression_strength: 21,
          specific_weight: 0.00002352
        ),
        cover_lateral: 50,
        cover_top: 50,
        cover_bottom: 75
      )
    end

    let(:load_scenario) do
      StructuraidCore::Loads::Scenarios::Footings::CentricIsolated.new(
        service_load: StructuraidCore::Loads::PointLoad.new(
          value: -112_500,
          location: StructuraidCore::Engineering::Locations::Absolute.new(
            value_x: 0,
            value_y: 0,
            value_z: 0
          ),
          label: 'Service Load'
        ),
        ultimate_load: StructuraidCore::Loads::PointLoad.new(
          value: -152_500,
          location: StructuraidCore::Engineering::Locations::Absolute.new(
            value_x: 0,
            value_y: 0,
            value_z: 0
          ),
          label: 'Service Load'
        )
      )
    end

    let(:height) { 500 }

    let(:analysis_direction) { :length_1 }

    let(:design_code) { StructuraidCore::DesignCodes::NSR10 }

    it 'is a success' do
      expect(result).to be_a_success
    end

    it 'returns the design bending momentum' do
      expect(result.analysis_results[:bending_momentum]).to eq(57_187_500.0)
    end

    it 'returns the design required reinforcement ratio' do
      expect(result.analysis_results[:required_reinforcement_ratio]).to eq(0.0025)
    end

    describe 'when the footing doesnt require reinforcement for flexural solicitations' do
      let(:height) { 1000 }

      it 'is a success' do
        expect(result).to be_a_success
      end

      it 'returns the minimum reinforcement ratio' do
        expect(result.analysis_results[:required_reinforcement_ratio]).to eq(0.0025)
      end
    end

    describe 'when the flexural solicitation is too high for the footing' do
      let(:height) { 80 }

      it 'is a failure' do
        expect(result).to be_a_failure
      end

      it 'raises a message' do
        expect(result.message).to match('is too hight for this element')
      end
    end
  end
end
