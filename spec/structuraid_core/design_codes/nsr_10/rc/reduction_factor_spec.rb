require 'spec_helper'

# rubocop:disable RSpec/FilePath
RSpec.describe StructuraidCore::DesignCodes::NSR10::RC::ReductionFactor do
  describe '.call' do
    describe 'when strength controlling behaviour has a wrong value' do
      subject(:result) do
        described_class.call(
          strength_controlling_behaviour:
        )
      end

      let(:strength_controlling_behaviour) { :wron_control_value }

      it 'raises an error' do
        expect { result }.to raise_error(StructuraidCore::DesignCodes::UnrecognizedValueError)
      end
    end

    describe 'when strength controlling is tension_controlled' do
      subject(:result) do
        described_class.call(
          strength_controlling_behaviour:
        )
      end

      let(:strength_controlling_behaviour) { :tension_controlled }

      it 'returns the right reduction factor' do
        expect(result).to eq(0.90)
      end
    end

    describe 'when strength controlling is compression_controlled' do
      subject(:result) do
        described_class.call(
          params
        )
      end

      describe 'when reinforcement is provided by steel coils' do
        let(:params) do
          {
            strength_controlling_behaviour: :compression_controlled,
            is_coil_rebar: true
          }
        end

        it 'returns the right reduction factor' do
          expect(result).to eq(0.75)
        end
      end

      describe 'when reinforcement is provided by other steel rebar' do
        let(:params) do
          {
            strength_controlling_behaviour: :compression_controlled
          }
        end

        it 'returns the right reduction factor' do
          expect(result).to eq(0.65)
        end
      end
    end
  end
end
# rubocop:enable RSpec/FilePath
