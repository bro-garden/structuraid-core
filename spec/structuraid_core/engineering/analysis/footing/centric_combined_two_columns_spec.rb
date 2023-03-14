require 'spec_helper'

RSpec.describe StructuraidCore::Engineering::Analysis::Footing::CentricCombinedTwoColumns do
  subject(:centric_combined_footing) do
    described_class.new(footing:, loads_from_columns:, section_direction:)
  end

  let(:load_from_column) { StructuraidCore::Loads::PointLoad.new(value: 1500, location: nil) }
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
  let(:length_1) { 8000 }
  let(:length_2) { 3000 }
  let(:height) { 250 }
  let(:cover_lateral) { 50 }
  let(:cover_top) { 50 }
  let(:cover_bottom) { 75 }
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

  describe '#solicitation_load' do
    let(:expected_solicitation) { loads_from_columns.sum(&:value) / length_1 }

    it 'returns the right solicitation on the food' do
      expect(centric_combined_footing.solicitation_load).to be(expected_solicitation)
    end
  end

  describe '#absolute_centroid' do
    let(:expected_centroid) { StructuraidCore::Engineering::Locations::Absolute.new(value_x: 0, value_y: 3000, value_z: 0) }

    it 'returns an Engineering::Locations::Absolute object' do
      expect(centric_combined_footing.absolute_centroid).to be_an_instance_of(StructuraidCore::Engineering::Locations::Absolute)
    end

    it 'returns right centroif' do
      expect(
        centric_combined_footing.absolute_centroid.to_matrix.to_a
      ).to match_array(expected_centroid.to_matrix.to_a)
    end
  end

  # describe '#geometry' do
  #   it 'returns an array of loads' do
  #     centric_combined_footing.geometry
  #   end
  # end
end
