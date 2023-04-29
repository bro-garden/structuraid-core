require 'spec_helper'
require 'byebug'

RSpec.describe StructuraidCore::Engineering::Locations::CoordinatesSystem do
  subject(:coord_system) { described_class.new(anchor_location:) }

  let(:value_x) { 0.0 }
  let(:value_y) { 0.0 }
  let(:value_z) { 0.0 }
  let(:value_1) { 4.0 }
  let(:value_2) { 3.0 }
  let(:value_3) { 0.0 }
  let(:anchor_location) { StructuraidCore::Engineering::Locations::Absolute.new(value_x:, value_y:, value_z:) }
  let(:relative_1) do
    StructuraidCore::Engineering::Locations::Relative.new(value_1:, value_2:, value_3:, label: :label_1)
  end
  let(:relative_2) do
    StructuraidCore::Engineering::Locations::Relative.new(value_1: -5, value_2: 0.0, value_3:, label: :label_2)
  end

  before do
    coord_system.add_location(relative_1)
  end

  describe '#align_axis_1_with' do
    describe 'border cases' do
      before do
        coord_system.align_axis_1_with(vector:)
      end

      describe 'when vector is parallel to axis 1 and same direction' do
        let(:vector) { Vector[1.0, 0.0, 0.0] }

        it 'updates axis 1' do
          expect(coord_system.axis_1.to_a).to eq([1.0, 0.0, 0.0])
        end

        it 'updates relative locations' do
          obtained_coordinates = coord_system.relative_locations.first.to_matrix.to_a.map do |coord|
            [coord.first.round(2)]
          end
          expect(obtained_coordinates).to eq([[4.0], [3.0], [0.0]])
        end
      end

      describe 'when vector is parallel to axis 2 and same direction' do
        let(:vector) { Vector[0.0, 1.0, 0.0] }

        it 'updates axis 1' do
          expect(coord_system.axis_1.to_a).to eq([0.0, 1.0, 0.0])
        end

        it 'updates relative locations' do
          obtained_coordinates = coord_system.relative_locations.first.to_matrix.to_a.map do |coord|
            [coord.first.round(2)]
          end
          expect(obtained_coordinates).to eq([[3.0], [-4.0], [0.0]])
        end
      end

      describe 'when vector is parallel to axis 1 and oposite direction' do
        let(:vector) { Vector[-1.0, 0.0, 0.0] }

        it 'updates axis 1' do
          expect(coord_system.axis_1.to_a).to eq([-1.0, 0.0, 0.0])
        end

        it 'updates relative locations' do
          obtained_coordinates = coord_system.relative_locations.first.to_matrix.to_a.map do |coord|
            [coord.first.round(2)]
          end
          expect(obtained_coordinates).to eq([[-4.0], [-3.0], [0.0]])
        end
      end

      describe 'when vector is parallel to axis 2 and oposite direction' do
        let(:vector) { Vector[0.0, -1.0, 0.0] }

        it 'updates axis 1' do
          expect(coord_system.axis_1.to_a).to eq([0.0, -1.0, 0.0])
        end

        it 'updates relative locations' do
          obtained_coordinates = coord_system.relative_locations.first.to_matrix.to_a.map do |coord|
            [coord.first.round(2)]
          end
          expect(obtained_coordinates).to eq([[-3.0], [4.0], [0.0]])
        end
      end
    end

    describe 'allign...' do
      let(:vector_first_alignment) { Vector[value_1, value_2, 0.0] }

      before do
        coord_system.align_axis_1_with(vector: vector_first_alignment)
        coord_system.add_location(relative_2)
      end

      describe 'and add a location' do
        it 'updates relative locations' do
          obtained_coordinates = coord_system.relative_locations.map do |location|
            location.to_matrix.to_a.map { |coord| [coord.first.round(2)] }
          end
          expect(obtained_coordinates).to eq([[[5.0], [0.0], [0.0]], [[-5.0], [0.0], [0.0]]])
        end
      end

      describe 'add a location, and allign again' do
        let(:vector_second_alignment) { Vector[1.0, 0.0, 0.0] }

        before do
          coord_system.align_axis_1_with(vector: vector_second_alignment)
        end

        it 'updates relative locations' do
          obtained_coordinates = coord_system.relative_locations.map do |location|
            location.to_matrix.to_a.map { |coord| [coord.first.round(2)] }
          end
          expect(obtained_coordinates).to eq([[[value_1], [value_2], [value_3]], [[-value_1], [-value_2], [value_3]]])
        end
      end
    end
  end

  describe '#find_or_add_location_from_vector' do
    xit 'finds or adds a location to collection'
  end

  # TODO: Add specs for other methods
end
