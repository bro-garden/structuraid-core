require 'spec_helper'

RSpec.describe StructuraidCore::Elements::Footing do
  subject(:footing) do
    described_class.new(
      length_1:,
      length_2:,
      height:,
      material: StructuraidCore::Materials::Concrete.new(elastic_module: 1800, design_compression_strength: 28, specific_weight: 2.4),
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
end
