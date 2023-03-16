require 'spec_helper'
require 'byebug'

RSpec.describe StructuraidCore::Engineering::Analysis::Footing::CentricCombinedTwoColumns do
  subject(:centric_combined_footing) do
    described_class.new(
      footing:,
      loads_from_columns:,  
      section_direction:
    )
  end

  let(:length_1) { 10_000 }
  let(:length_2) { 3000 }
  let(:height) { 250 }
  let(:cover_lateral) { 50 }
  let(:cover_top) { 50 }
  let(:cover_bottom) { 75 }
  let(:section_direction) { :length_1 }

  let(:footing) do
    StructuraidCore::Elements::Footing.new(
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
      longitudinal_bottom_reinforcement_length_1: nil,
      longitudinal_bottom_reinforcement_length_2: nil
    )
  end
  let(:loads_from_columns) do
    [
      StructuraidCore::Loads::PointLoad.new(
        value: 40_000,
        location: StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 0,
          value_y: 4000,
          value_z: 0
        )
      ),
      StructuraidCore::Loads::PointLoad.new(
        value: 10_000,
        location: StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 0,
          value_y: -1000,
          value_z: 0
        )
      )
    ]
  end
  let(:lcs) do
    StructuraidCore::Engineering::Locations::CoordinatesSystem.new(
      anchor_location: centric_combined_footing.absolute_centroid
    )
  end

  describe '#solicitation_load' do
    let(:expected_solicitation) { loads_from_columns.sum(&:value) / length_1 }

    it 'returns the right solicitation on the food' do
      expect(centric_combined_footing.solicitation_load).to be(expected_solicitation)
    end
  end

  describe '#absolute_centroid' do
    let(:expected_centroid) do
      StructuraidCore::Engineering::Locations::Absolute.new(
        value_x: 0,
        value_y: 3000,
        value_z: 0
      )
    end

    it 'returns an Engineering::Locations::Absolute object' do
      expect(
        centric_combined_footing.absolute_centroid
      ).to be_an_instance_of(StructuraidCore::Engineering::Locations::Absolute)
    end

    it 'returns right centroif' do
      expect(
        centric_combined_footing.absolute_centroid.to_matrix.to_a
      ).to match_array(expected_centroid.to_matrix.to_a)
    end
  end

  describe '#build_geometry' do
    before do
      footing.add_coordinates_system(lcs)
      centric_combined_footing.build_geometry(footing.coordinates_system)
    end

    it 'updates locations at coordinates system' do
      expect(footing.coordinates_system.relative_locations.count).to eq(4)
    end

    # rubocop:disable RSpec/ExampleLength
    it 'updates longitudes' do
      expect(
        [
          centric_combined_footing.send(:long_stretch_1).round(1),
          centric_combined_footing.send(:long_stretch_2).round(1),
          centric_combined_footing.send(:long_stretch_3).round(1)
        ]
      ).to eq([4000.0, 5000.0, 1000.0])
    end
    # rubocop:enable RSpec/ExampleLength
  end

  describe '#reaction_1' do
    before do
      footing.add_coordinates_system(lcs)
      centric_combined_footing.build_geometry(footing.coordinates_system)
    end

    it 'returns right reaction 1' do
      reactions = [
        -loads_from_columns.first.value,
        -loads_from_columns.last.value
      ]
      expect(reactions.include?(centric_combined_footing.reaction_1.round(1))).to be(true)
    end
  end

  describe '#reaction_2' do
    before do
      footing.add_coordinates_system(lcs)
      centric_combined_footing.build_geometry(footing.coordinates_system)
    end

    it 'returns right reaction 2' do
      reactions = [
        -loads_from_columns.first.value,
        -loads_from_columns.last.value
      ]
      expect(reactions.include?(centric_combined_footing.reaction_1.round(1))).to be(true)
    end
  end

  describe '#shear_at' do
    before do
      footing.add_coordinates_system(lcs)
      centric_combined_footing.build_geometry(footing.coordinates_system)
    end

    describe 'at x = 0' do
      it 'returns 0' do
        expect(centric_combined_footing.shear_at(0)).to eq([0.0, 0.0, 0.0])
      end
    end

    describe 'at x = long_stretch_1' do
      it 'returns reaction_1 with left+right' do
        shear_at_long_1 = centric_combined_footing.shear_at(centric_combined_footing.send(:long_stretch_1))
        expect((shear_at_long_1[0] - shear_at_long_1[1]).abs).to eq(centric_combined_footing.reaction_1.abs)
      end
    end

    describe 'at x = long_stretch_1 + long_stretch_2' do
      it 'returns reaction_2 with left+right' do
        shear_at_long_1 = centric_combined_footing.shear_at(
          centric_combined_footing.send(:long_stretch_1) + centric_combined_footing.send(:long_stretch_2)
        )
        expect((shear_at_long_1[1] - shear_at_long_1[2]).abs).to eq(centric_combined_footing.reaction_2.abs)
      end
    end

    describe 'at x = long_stretch_1 + long_stretch_2 + long_stretch_3' do
      it 'returns reaction_2 with left+right' do
        expect(
          centric_combined_footing.shear_at(centric_combined_footing.send(:section_length))
        ).to eq([0.0, 0.0, 0.0])
      end
    end
  end
end
