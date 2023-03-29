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
        value: -40_000,
        location: StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 1000,
          value_y: 4000,
          value_z: 0
        )
      ),
      StructuraidCore::Loads::PointLoad.new(
        value: -10_000,
        location: StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 1000,
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
    let(:expected_solicitation) { 5.00 }

    it 'returns the right solicitation on the food' do
      expect(centric_combined_footing.solicitation_load.round(2)).to be(expected_solicitation)
    end
  end

  describe '#absolute_centroid' do
    let(:expected_centroid) do
      StructuraidCore::Engineering::Locations::Absolute.new(
        value_x: 1000,
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
    let(:long_border_to_first_column) { centric_combined_footing.send(:long_border_to_first_column).round(1) }
    let(:long_first_column_to_second_column) do
      centric_combined_footing.send(:long_first_column_to_second_column).round(1)
    end
    let(:long_second_column_to_border) { centric_combined_footing.send(:long_second_column_to_border).round(1) }

    before do
      footing.add_coordinates_system(lcs)
      centric_combined_footing.build_geometry
    end

    it 'updates locations at coordinates system' do
      expect(footing.coordinates_system.relative_locations.count).to eq(4)
    end

    it 'updates longitudes' do
      expect(
        [
          long_border_to_first_column, long_first_column_to_second_column, long_second_column_to_border
        ]
      ).to eq([4000.0, 5000.0, 1000.0])
    end
  end

  describe '#reaction_at_first_column' do
    before do
      footing.add_coordinates_system(lcs)
      centric_combined_footing.build_geometry
    end

    it 'returns right reaction 1' do
      reactions = [
        loads_from_columns.first.value,
        loads_from_columns.last.value
      ]
      expect(reactions.include?(centric_combined_footing.reaction_at_first_column.round(1))).to be(true)
    end
  end

  describe '#reaction_at_second_column' do
    before do
      footing.add_coordinates_system(lcs)
      centric_combined_footing.build_geometry
    end

    it 'returns right reaction 2' do
      reactions = [
        loads_from_columns.first.value,
        loads_from_columns.last.value
      ]
      expect(reactions.include?(centric_combined_footing.reaction_at_first_column.round(1))).to be(true)
    end
  end

  describe '#shear_at' do
    before do
      footing.add_coordinates_system(lcs)
      centric_combined_footing.build_geometry
    end

    describe 'at x = 0' do
      it 'returns 0' do
        expect(centric_combined_footing.shear_at(0)).to eq([0.0])
      end
    end

    describe 'at x = long_border_to_first_column' do
      let(:long_1) { centric_combined_footing.send(:long_border_to_first_column) }
      let(:first_column_reaction) { centric_combined_footing.reaction_at_first_column.abs }

      it 'returns reaction_at_first_column with left+right' do
        shear_at_long_1 = centric_combined_footing.shear_at(long_1)
        expect((shear_at_long_1[0] - shear_at_long_1[1]).abs).to eq(first_column_reaction)
      end
    end

    describe 'at x = long_border_to_first_column + long_first_column_to_second_column' do
      let(:long_1) { centric_combined_footing.send(:long_border_to_first_column) }
      let(:long_2) { centric_combined_footing.send(:long_first_column_to_second_column) }
      let(:second_column_reaction) { centric_combined_footing.reaction_at_second_column.abs }

      it 'returns reaction_at_second_column with left+right' do
        shear_at_long_1 = centric_combined_footing.shear_at(long_1 + long_2)
        expect((shear_at_long_1[0] - shear_at_long_1[1]).abs).to eq(second_column_reaction)
      end
    end

    describe 'at x = long_border_to_first_column + long_first_column_to_second_column + long_second_column_to_border' do
      it 'returns reaction_at_second_column with left+right' do
        expect(
          centric_combined_footing.shear_at(centric_combined_footing.send(:section_length))
        ).to eq([0.0])
      end
    end
  end

  describe '#moment_at' do
    before do
      footing.add_coordinates_system(lcs)
      centric_combined_footing.build_geometry
    end

    describe 'at x = 0' do
      it 'returns 0' do
        expect(centric_combined_footing.moment_at(0)).to eq([0.0])
      end
    end

    describe 'at x = long_border_to_first_column' do
      let(:expected_moment) { 2_500_000 }
      let(:resulting_moment) do
        centric_combined_footing.moment_at(
          centric_combined_footing.send(:long_border_to_first_column)
        )
      end

      it 'returns the same value left and right of x' do
        expect(resulting_moment[0] == resulting_moment[1]).to eq(true)
      end
    end

    describe 'at x = long_border_to_first_column + long_first_column_to_second_column' do
      let(:resulting_moment) do
        centric_combined_footing.moment_at(
          centric_combined_footing.send(
            :long_border_to_first_column
          ) + centric_combined_footing.send(
            :long_first_column_to_second_column
          )
        )
      end

      it 'returns the same value left and right of x' do
        expect(resulting_moment[0] == resulting_moment[1]).to eq(true)
      end
    end

    describe 'at x = long_border_to_first_column + long_first_column_to_second_column + long_second_column_to_border' do
      it 'returns reaction_at_second_column with left+right' do
        expect(
          centric_combined_footing.moment_at(centric_combined_footing.send(:section_length))
        ).to eq([0.0])
      end
    end
  end

  describe '#moment_inflection_point' do
    before do
      footing.add_coordinates_system(lcs)
      centric_combined_footing.build_geometry
    end

    it 'returns rigth distance, from first border of the footing' do
      expect(
        centric_combined_footing.moment_inflection_point
      ).to eq(-centric_combined_footing.reaction_at_first_column / centric_combined_footing.solicitation_load)
    end
  end

  describe '#maximum_moment' do
    let(:point_of_maximum_moment) { centric_combined_footing.moment_inflection_point }
    let(:expect_result) do
      [
        centric_combined_footing.moment_at(point_of_maximum_moment * 0.90)[0],
        centric_combined_footing.maximum_moment[0],
        centric_combined_footing.moment_at(point_of_maximum_moment * 1.10)[0]
      ]
    end

    before do
      footing.add_coordinates_system(lcs)
      centric_combined_footing.build_geometry
    end

    it 'returns rigth distance, from first border of the footing' do
      expect(
        expect_result[0] > expect_result[1] && expect_result[1] < expect_result[2]
      ).to be(true)
    end
  end
end
