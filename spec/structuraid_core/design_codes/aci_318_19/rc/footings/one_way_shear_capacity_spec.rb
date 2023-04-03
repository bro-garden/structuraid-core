require 'spec_helper'

# rubocop:disable RSpec/FilePath
RSpec.describe StructuraidCore::DesignCodes::ACI31819::RC::Footings::OneWayShearCapacity do
  describe '.call' do
    subject(:result) do
      described_class.call(
        design_compression_strength:,
        width:,
        effective_height:,
        light_concrete_modification_factor:
      )
    end

    let(:width) { 2_500 } # mm
    let(:effective_height) { 450 } # mm
    let(:light_concrete_modification_factor) { 1.0 }

    describe 'when concrete is 28MPa' do
      let(:design_compression_strength) { 28 } # N/(mm**2)

      it 'returns right capacity' do
        effective_area = effective_height * width
        concrete_strength = light_concrete_modification_factor * Math.sqrt(design_compression_strength)

        expect(result).to eq(0.17 * concrete_strength * effective_area)
      end
    end

    describe 'when concrete is 42MPa' do
      let(:design_compression_strength) { 42 } # N/(mm**2)

      it 'returns right capacity' do
        effective_area = effective_height * width
        concrete_strength = light_concrete_modification_factor * Math.sqrt(design_compression_strength)

        expect(result).to eq(0.17 * concrete_strength * effective_area)
      end
    end
  end
end
# rubocop:enable RSpec/FilePath
