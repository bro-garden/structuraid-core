require 'spec_helper'

# rubocop:disable RSpec/FilePath
RSpec.describe StructuraidCore::DesignCodes::NSR10::RC::MinimumSteelCover do
  describe '.call' do
    subject(:result) { described_class.call(params) }

    describe 'when concrete casting or exposision case not passed' do
      let(:params) do
        {
          concrete_casting_against_soil: nil,
          environment_exposure: nil,
          structural_element: nil,
          maximum_rebar_diameter: nil
        }
      end

      it 'raises an error' do
        expect { result }.to raise_error(StructuraidCore::DesignCodes::MissingParamError)
      end
    end

    describe 'when concrete_casting_against_soil is true' do
      let(:params) do
        {
          concrete_casting_against_soil: true,
          environment_exposure: false,
          structural_element: nil,
          maximum_rebar_diameter: nil
        }
      end

      it 'returns the right cover' do
        expect(result).to eq(75)
      end
    end

    describe 'when environment_exposure is true' do
      let(:params) do
        {
          concrete_casting_against_soil: false,
          environment_exposure: true,
          structural_element: nil,
          maximum_rebar_diameter: nil
        }
      end

      it 'returns the right cover' do
        expect(result).to eq(50)
      end

      describe 'when environment_exposure is and maximum_rebar_diameter is greater than 16mm' do
        let(:params) do
          {
            concrete_casting_against_soil: false,
            environment_exposure: true,
            structural_element: described_class::STRUCTURAL_ELEMENTS.sample,
            maximum_rebar_diameter: 17
          }
        end

        it 'returns the right cover' do
          expect(result).to eq(50)
        end
      end

      describe 'when environment_exposure is and maximum_rebar_diameter is less than 16mm' do
        let(:params) do
          {
            concrete_casting_against_soil: false,
            environment_exposure: true,
            structural_element: described_class::STRUCTURAL_ELEMENTS.sample,
            maximum_rebar_diameter: (1..16).to_a.sample
          }
        end

        it 'returns the right cover' do
          expect(result).to eq(40)
        end
      end
    end

    describe 'when environment_exposure is false and concrete_casting_against_soil is false' do
      let(:params) do
        {
          concrete_casting_against_soil: false,
          environment_exposure: false,
          structural_element: nil,
          maximum_rebar_diameter: nil
        }
      end

      it 'returns the right cover' do
        expect(result).to eq(50)
      end

      describe 'when structural_element is one of [slab wall joist]' do
        describe 'when maximum_rebar_diameter is nil' do
          let(:params) do
            {
              concrete_casting_against_soil: false,
              environment_exposure: false,
              structural_element: %i[slab wall joist].sample,
              maximum_rebar_diameter: nil
            }
          end

          it 'returns the right cover' do
            expect(result).to eq(40)
          end
        end

        describe 'when maximum_rebar_diameter is greater than 36' do
          let(:params) do
            {
              concrete_casting_against_soil: false,
              environment_exposure: false,
              structural_element: %i[slab wall joist].sample,
              maximum_rebar_diameter: 37
            }
          end

          it 'returns the right cover' do
            expect(result).to eq(40)
          end
        end

        describe 'when maximum_rebar_diameter less than 36' do
          let(:params) do
            {
              concrete_casting_against_soil: false,
              environment_exposure: false,
              structural_element: %i[slab wall joist].sample,
              maximum_rebar_diameter: (1..36).to_a.sample
            }
          end

          it 'returns the right cover' do
            expect(result).to eq(20)
          end
        end
      end

      describe 'when structural_element is one of [shell thin_shell]' do
        describe 'when maximum_rebar_diameter is nil' do
          let(:params) do
            {
              concrete_casting_against_soil: false,
              environment_exposure: false,
              structural_element: %i[shell thin_shell].sample,
              maximum_rebar_diameter: nil
            }
          end

          it 'returns the right cover' do
            expect(result).to eq(20)
          end
        end

        describe 'when maximum_rebar_diameter is greater than 16' do
          let(:params) do
            {
              concrete_casting_against_soil: false,
              environment_exposure: false,
              structural_element: %i[shell thin_shell].sample,
              maximum_rebar_diameter: 17
            }
          end

          it 'returns the right cover' do
            expect(result).to eq(20)
          end
        end

        describe 'when maximum_rebar_diameter less than 16' do
          let(:params) do
            {
              concrete_casting_against_soil: false,
              environment_exposure: false,
              structural_element: %i[shell thin_shell].sample,
              maximum_rebar_diameter: (1..16).to_a.sample
            }
          end

          it 'returns the right cover' do
            expect(result).to eq(13)
          end
        end
      end

      describe 'when structural_element is one of [beam column]' do
        let(:params) do
          {
            concrete_casting_against_soil: false,
            environment_exposure: false,
            structural_element: %i[beam column].sample,
            maximum_rebar_diameter: nil
          }
        end

        it 'returns the right cover' do
          expect(result).to eq(40)
        end
      end
    end
  end
end
# rubocop:enable RSpec/FilePath
