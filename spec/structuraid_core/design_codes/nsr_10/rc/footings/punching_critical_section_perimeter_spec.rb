require 'spec_helper'

# rubocop:disable RSpec/FilePath
RSpec.describe StructuraidCore::DesignCodes::NSR10::RC::Footings::PunchingCriticalSectionPerimeter do
  let(:footing) { build(:footing, length_1: 2500, length_2: 1000, height: 300) }
  let(:column_label) { :column }

  before do
    lcs = build(:coordinates_system, :ucs)
    footing.add_coordinates_system(lcs)

    allow(footing).to receive(:effective_height).and_return(450)
  end

  describe '.call' do
    subject(:result) do
      described_class.call(
        column_section_length_1:,
        column_section_length_2:,
        column_absolute_location:,
        column_label:,
        footing:
      )
    end

    let(:column_section_length_1) { 450 }
    let(:column_section_length_2) { 250 }

    describe 'column at: (-1025, 375, 0)' do
      let(:column_absolute_location) { build(:absolute_location, value_x: -1025, value_y: 375, value_z: 0) }
      let(:expected_perimeter) { 1150 }

      it 'returns the right perimeter' do
        expect(result).to eq(expected_perimeter)
      end
    end

    describe 'column at: (0, 375, 0)' do
      let(:column_absolute_location) { build(:absolute_location, value_x: 0, value_y: 375, value_z: 0) }
      let(:expected_perimeter) { 1850 }

      it 'returns the right perimeter' do
        expect(result).to eq(expected_perimeter)
      end
    end

    describe 'column at: (1025, 375, 0)' do
      let(:column_absolute_location) { build(:absolute_location, value_x: 1025, value_y: 375, value_z: 0) }
      let(:expected_perimeter) { 1150 }

      it 'returns the right perimeter' do
        expect(result).to eq(expected_perimeter)
      end
    end

    describe 'column at: (-1025, 0, 0)' do
      let(:column_absolute_location) { build(:absolute_location, value_x: -1025, value_y: 0, value_z: 0) }
      let(:expected_perimeter) { 2050 }

      it 'returns the right perimeter' do
        expect(result).to eq(expected_perimeter)
      end
    end

    describe 'column at: (0, 0, 0)' do
      let(:column_absolute_location) { build(:absolute_location, :origin) }
      let(:expected_perimeter) { 3200 }

      it 'returns the right perimeter' do
        expect(result).to eq(expected_perimeter)
      end
    end

    describe 'column at: (1025, 0, 0)' do
      let(:column_absolute_location) { build(:absolute_location, value_x: 1025, value_y: 0, value_z: 0) }
      let(:expected_perimeter) { 2050 }

      it 'returns the right perimeter' do
        expect(result).to eq(expected_perimeter)
      end
    end

    describe 'column at: (-1025, -375, 0)' do
      let(:column_absolute_location) { build(:absolute_location, value_x: -1025, value_y: -375, value_z: 0) }
      let(:expected_perimeter) { 1150 }

      it 'returns the right perimeter' do
        expect(result).to eq(expected_perimeter)
      end
    end

    describe 'column at: (0, -375, 0)' do
      let(:column_absolute_location) { build(:absolute_location, value_x: 0, value_y: -375, value_z: 0) }
      let(:expected_perimeter) { 1850 }

      it 'returns the right perimeter' do
        expect(result).to eq(expected_perimeter)
      end
    end

    describe 'column at: (1025, -375, 0)' do
      let(:column_absolute_location) { build(:absolute_location, value_x: 1025, value_y: -375, value_z: 0) }
      let(:expected_perimeter) { 1150 }

      it 'returns the right perimeter' do
        expect(result).to eq(expected_perimeter)
      end
    end
  end
end
# rubocop:enable RSpec/FilePath
