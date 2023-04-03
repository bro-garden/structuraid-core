require 'spec_helper'

# rubocop:disable RSpec/FilePath
RSpec.describe StructuraidCore::DesignCodes::NSR10::RC::ReductionFactor do
  let(:max_strain_before_transition) do
    StructuraidCore::DesignCodes::NSR10::RC::ReductionFactor::MAX_STRAIN_BEFORE_TRANSITION
  end
  let(:min_strain_after_transition) do
    StructuraidCore::DesignCodes::NSR10::RC::ReductionFactor::MIN_STRAIN_AFTER_TRANSITION
  end

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

    describe 'when strength controlling is shear_nonseismic_controller || strud_and_tie_controlled' do
      subject(:result) do
        described_class.call(
          params
        )
      end

      let(:params) do
        {
          strength_controlling_behaviour: %i[shear_nonseismic_controller strud_and_tie_controlled].sample
        }
      end

      it 'returns the right reduction factor' do
        expect(result).to eq(0.75)
      end
    end

    describe 'when strength controlling is transition_controlled' do
      subject(:result) do
        described_class.call(
          params
        )
      end

      describe 'when reinforcement is provided by steel coils' do
        describe 'when no strain is provided' do
          let(:params) do
            {
              strength_controlling_behaviour: :transition_controlled,
              is_coil_rebar: true
            }
          end

          it 'raises an error' do
            expect { result }.to raise_error(StructuraidCore::DesignCodes::MissingParamError)
          end
        end

        describe 'when strain is a value in (0.001...max_strain_before_transition)' do
          let(:params) do
            {
              strength_controlling_behaviour: :transition_controlled,
              is_coil_rebar: true,
              strain: (0.001...max_strain_before_transition).step(0.0001).to_a.sample
            }
          end

          it 'returns the right reduction factor' do
            expect(result).to eq(0.75)
          end
        end

        describe 'when strain is a value prominent than min_strain_after_transition' do
          let(:params) do
            {
              strength_controlling_behaviour: :transition_controlled,
              is_coil_rebar: true,
              strain: min_strain_after_transition + 0.001
            }
          end

          it 'returns the right reduction factor' do
            expect(result).to eq(0.90)
          end
        end

        describe 'when strain is in the middle of the transition' do
          let(:params) do
            {
              strength_controlling_behaviour: :transition_controlled,
              is_coil_rebar: true,
              strain: (min_strain_after_transition + max_strain_before_transition) / 2
            }
          end

          it 'returns the right reduction factor' do
            expect(result.round(3)).to eq(((0.75 + 0.90) / 2).round(3))
          end
        end
      end

      describe 'when reinforcement is provided by other steel rebar' do
        describe 'when no strain is provided' do
          let(:params) do
            {
              strength_controlling_behaviour: :transition_controlled
            }
          end

          it 'raises an error' do
            expect { result }.to raise_error(StructuraidCore::DesignCodes::MissingParamError)
          end
        end

        describe 'when strain is a value in (0.001...max_strain_before_transition)' do
          let(:params) do
            {
              strength_controlling_behaviour: :transition_controlled,
              strain: (0.001...max_strain_before_transition).step(0.0001).to_a.sample
            }
          end

          it 'returns the right reduction factor' do
            expect(result).to eq(0.65)
          end
        end

        describe 'when strain is a value prominent than min_strain_after_transition' do
          let(:params) do
            {
              strength_controlling_behaviour: :transition_controlled,
              strain: min_strain_after_transition + 0.001
            }
          end

          it 'returns the right reduction factor' do
            expect(result).to eq(0.90)
          end
        end

        describe 'when strain is in the middle of the transition' do
          let(:params) do
            {
              strength_controlling_behaviour: :transition_controlled,
              strain: (min_strain_after_transition + max_strain_before_transition) / 2
            }
          end

          it 'returns the right reduction factor' do
            expect(result.round(3)).to eq(((0.65 + 0.90) / 2).round(3))
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/FilePath
