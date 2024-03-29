require 'spec_helper'

RSpec.describe StructuraidCore::Designers::Footings::Steps::CentricIsolated::ComputeRequiredRebarRatio do
  describe '.call' do
    subject(:result) do
      described_class.call(
        footing:,
        load_scenario:,
        analysis_direction: :length_1,
        design_code: StructuraidCore::DesignCodes::Nsr10,
        steel: build(:steel)
      )
    end

    let(:footing) do
      build(
        :footing,
        length_1: 1500,
        length_2: 1500,
        height:,
        material: build(:concrete, design_compression_strength: 21)
      )
    end

    let(:load_location) { build(:absolute_location) }

    let(:height) { 500 }

    let(:load_scenario) do
      build(
        :loads_scenarios_centric_isolated,
        service_load: build(:point_load, value: -112_500, location: load_location),
        ultimate_load: build(:point_load, value: -900_000, location: load_location)
      )
    end

    it 'is a success' do
      expect(result).to be_a_success
    end

    it 'returns the design bending momentum' do
      expect(result.analysis_results[:bending_momentum]).to eq(-337_500_000.0)
    end

    it 'returns the design required reinforcement ratio' do
      expect(result.analysis_results[:computed_ratio]).to eq(0.0030491561521242693)
    end

    it 'returns the minimum reinforcement ratio, and struct field with false value' do
      expect(result.analysis_results[:is_minimum_ratio]).to eq(false)
    end

    describe 'when the footing doesnt require reinforcement for flexural solicitations' do
      let(:height) { 1000 }

      let(:load_scenario) do
        build(
          :loads_scenarios_centric_isolated,
          service_load: build(:point_load, value: -112_500, location: load_location),
          ultimate_load: build(:point_load, value: -152_500, location: load_location)
        )
      end

      it 'is a success' do
        expect(result).to be_a_success
      end

      it 'returns the minimum reinforcement ratio' do
        expect(result.analysis_results[:computed_ratio]).to eq(0.0025)
      end

      it 'returns the minimum reinforcement ratio, and struct field with true value' do
        expect(result.analysis_results[:is_minimum_ratio]).to eq(true)
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
