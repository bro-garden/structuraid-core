require 'spec_helper'

RSpec.describe StructuraidCore::Elements::Footing do
  subject(:footing) do
    described_class.new(
      length_1:,
      length_2:,
      height:,
      material: StructuraidCore::Materials::Concrete.new(
        elastic_module: 1800,
        design_compression_strength: 28,
        specific_weight: 2.4
      ),
      cover_lateral:,
      cover_top:,
      cover_bottom:,
      longitudinal_bottom_reinforcement_length_1:,
      longitudinal_bottom_reinforcement_length_2:
    )
  end

  let(:length_1) { 1500 }
  let(:length_2) { 1500 }
  let(:height) { 500 }
  let(:cover_lateral) { 50 }
  let(:cover_top) { 50 }
  let(:cover_bottom) { 75 }
  let(:longitudinal_bottom_reinforcement_length_1) do
    StructuraidCore::Elements::Reinforcement::StraightLongitudinal.new(
      distribution_direction: :length_1
    )
  end
  let(:longitudinal_bottom_reinforcement_length_2) do
    StructuraidCore::Elements::Reinforcement::StraightLongitudinal.new(
      distribution_direction: :length_2
    )
  end
  let(:rebar_material) { StructuraidCore::Materials::Steel.new(yield_stress: 4200) }
  let(:rebar_n3) do
    StructuraidCore::Elements::Reinforcement::Rebar.new(
      number: 3,
      material: rebar_material
    )
  end
  let(:start_location_1) do
    StructuraidCore::Engineering::Locations::Relative.new(
      value_1: -0.5 * length_1 + cover_lateral,
      value_2: -0.5 * length_2 + cover_lateral,
      value_3: cover_bottom
    )
  end
  let(:end_location_1) do
    StructuraidCore::Engineering::Locations::Relative.new(
      value_1: 0.5 * length_1 - cover_lateral,
      value_2: 0.5 * length_2 - cover_lateral,
      value_3: cover_bottom
    )
  end
  let(:start_location_2) do
    StructuraidCore::Engineering::Locations::Relative.new(
      value_1: -0.5 * length_1 + cover_lateral,
      value_2: -0.5 * length_2 + cover_lateral,
      value_3: cover_bottom
    )
  end
  let(:end_location_2) do
    StructuraidCore::Engineering::Locations::Relative.new(
      value_1: 0.5 * length_1 - cover_lateral,
      value_2: 0.5 * length_2 - cover_lateral,
      value_3: cover_bottom
    )
  end

  before do
    footing.longitudinal_bottom_reinforcement_length_1.add_layer(
      start_location: start_location_1,
      end_location: end_location_1,
      amount_of_rebars: 2,
      rebar: rebar_n3
    )
    footing.longitudinal_bottom_reinforcement_length_2.add_layer(
      start_location: start_location_2,
      end_location: end_location_2,
      amount_of_rebars: 2,
      rebar: rebar_n3
    )
    footing.longitudinal_bottom_reinforcement_length_2.layers.map do |layer|
      layer.reposition(above_middle: false, offset: rebar_n3.diameter)
    end
  end

  describe '#horizontal_area' do
    it 'returns the horizontal area of the footing' do
      expect(footing.horizontal_area).to eq(length_1 * length_2)
    end
  end

  describe '#effective_height' do
    describe 'when the footing has no longitudinal reinforcement' do
      it 'returns nil' do
        expect(
          footing.effective_height(section_direction: %i[length_1 length_2].sample, above_middle: true)
        ).to be_nil
      end
    end

    describe 'when the footing has longituinal reinforcement' do
      it 'returns the effective height of the footing for :lenth_1 section cut' do
        expected_effective_height = height - cover_bottom - 0.5 * rebar_n3.diameter
        expect(
          footing.effective_height(section_direction: :length_1, above_middle: false)
        ).to eq(expected_effective_height)
      end

      it 'returns the effective height of the footing for :lenth_2 section cut' do
        expected_effective_height = height - cover_bottom - rebar_n3.diameter - 0.5 * rebar_n3.diameter
        expect(
          footing.effective_height(section_direction: :length_2, above_middle: false)
        ).to eq(expected_effective_height)
      end
    end
  end

  describe '#find_or_add_column_location' do
    subject(:result) { footing.find_or_add_column_location(column_location, column_label) }

    let(:column_location) do
      StructuraidCore::Engineering::Locations::Absolute.new(value_x: 10, value_y: 20, value_z: 10)
    end
    let(:column_label) { :column }
    let(:coordinates_system) do
      StructuraidCore::Engineering::Locations::CoordinatesSystem.new(
        anchor_location: StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 5,
          value_y: 10,
          value_z: 20
        )
      )
    end

    before do
      footing.add_coordinates_system(coordinates_system)
    end

    it 'adds the column location to the coordinates system' do
      expect { result }.to change { coordinates_system.find_location('column_column') }.from(nil).to(anything)
    end

    it 'returns the column location relative to the footing system' do
      expect(result.to_vector).to eq(Vector[5, 10, -10])
    end

    describe 'when relative location is already present' do
      let(:existing_location) do
        StructuraidCore::Engineering::Locations::Relative.from_vector(
          Vector[5, 10, -10],
          label: :column_column
        )
      end

      before do
        coordinates_system.add_location(existing_location)
      end

      it 'returns the existing location' do
        expect(result).to eq(existing_location)
      end
    end
  end

  describe '#inside_me?' do
    subject { footing.inside_me?(location) }

    let(:location) do
      StructuraidCore::Engineering::Locations::Relative.new(value_1: 10, value_2: 20, value_3: 0, label: :label)
    end

    it { is_expected.to be_truthy }

    context 'when location is outside the footing' do
      let(:location) do
        StructuraidCore::Engineering::Locations::Relative.new(value_1: 10_000, value_2: -20_000, value_3: 0, label: :label)
      end

      it { is_expected.to be_falsey }
    end
  end
end
