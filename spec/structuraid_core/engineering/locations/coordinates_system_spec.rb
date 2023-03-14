require 'spec_helper'

RSpec.describe StructuraidCore::Engineering::Locations::CoordinatesSystem do
  subject(:coord_system) { described_class.new(anchor_location:) }

  let(:value_x) { 3.0 }
  let(:value_y) { 4.0 }
  let(:value_z) { 6.0 }
  let(:value_1) { 3.0 }
  let(:value_2) { 4.0 }
  let(:value_3) { 6.0 }
  let(:anchor_location) { StructuraidCore::Engineering::Locations::Absolute.new(value_x:, value_y:, value_z:) }
  let(:relative_1) { StructuraidCore::Engineering::Locations::Relative.new(value_1:, value_2:, value_3:) }
  let(:relative_2) { StructuraidCore::Engineering::Locations::Relative.new(value_1: -5.0, value_2: 0, value_3: 6) }

  describe '#axis_3' do
    let(:expected_initial_axis_3) { Vector[0.0, 0.0, 1.0] }

    it 'returns axis_3' do
      expect(coord_system.axis_3.to_a).to eq(expected_initial_axis_3.to_a)
    end
  end

  describe '#add' do
    it 'adds the relative location to relative_locations attribute' do
      coord_system.add(relative_location: relative_1)
      expect(coord_system.relative_locations).to include(relative_1)
    end
  end

  describe '#align_axis_1_with' do
    let(:vector) { relative_1.to_vector }

    describe 'when relative_locations is empty' do
      before do
        coord_system.align_axis_1_with(vector:)
      end

      it 'updates theta attribute' do
        expect(coord_system.send(:theta)).not_to be_zero
      end
    end

    describe 'when relative_locations is not empty' do
      let(:expected_rotated_coordinates) { [[5.0], [0.0], [6.0]] }

      before do
        coord_system.add(relative_location: relative_1)
        coord_system.align_axis_1_with(vector:)
      end

      it 'updates theta attribute' do
        expect(coord_system.send(:theta)).not_to be_zero
      end

      it 'updates relative locations' do
        obtained_coords = coord_system.relative_locations.first.to_matrix.to_a.map do |item|
          [item.first.round(1)]
        end
        expect(obtained_coords).to match_array(expected_rotated_coordinates)
      end
    end
  end

  describe '#align_axis_1_with_global_x' do
    let(:vector) { relative_1.to_vector }

    let(:expected_rotated_coordinates) do
      [
        [[3.0], [4.0], [6.0]],
        [[-3.0], [-4.0], [6.0]]
      ]
    end

    before do
      coord_system.add(relative_location: relative_1)
      coord_system.align_axis_1_with(vector:)
      coord_system.add(relative_location: relative_2)
      coord_system.align_axis_1_with_global_x
    end

    it 'updates theta attribute' do
      expect(coord_system.send(:theta)).to be_zero
    end

    it 'updates relative locations' do
      obtained_coords = coord_system.relative_locations.map(&:to_matrix).map do |matrix|
        matrix.to_a.map { |val| [val.first.round(1)] }
      end
      expect(obtained_coords).to match_array(expected_rotated_coordinates)
    end
  end
end
