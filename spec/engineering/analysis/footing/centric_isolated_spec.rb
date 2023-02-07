require 'spec_helper'
require 'engineering/analysis/footing/centric_isolated'
require 'elements/column/rectangular'
require 'elements/footing'
require 'loads/point_load'

RSpec.describe Engineering::Analysis::Footing::CentricIsolated do
  subject(:centric_isolated_footing) do
    described_class.new(column:, footing:, effective_height:, load_from_column:, section_direction:)
  end

  let(:column) do
    Elements::Column::Rectangular.new(length_x: 500, length_y: 300, height: 2900, material: 'concrete')
  end
  let(:footing) do
    Elements::Footing.new(length_x: 4000, length_y: 4000, height: 400, material: 'concrete')
  end
  let(:load_from_column) { Loads::PointLoad.new(value: 1500, location: nil) }
  let(:effective_height) { 250 }
  let(:section_direction) { :length_x }
  let(:orthogonal_direction) { :length_y }

  describe '#solicitation_load' do
    it 'returns the solicitation load for the cut direction' do
      expected_solicitation = load_from_column.value * footing.public_send(orthogonal_direction) / footing.horizontal_area
      expect(centric_isolated_footing.solicitation_load).to eq(expected_solicitation)
    end
  end

  describe '#max_shear_solicitation' do
    it 'returns the max shear solicitation' do
      expect(centric_isolated_footing.max_shear_solicitation).to eq(load_from_column.value)
    end
  end

  describe '#shear_solicitation' do
    it 'returns the shear solicitation, is less than the max_shear_solicitation' do
      expect(centric_isolated_footing.shear_solicitation < centric_isolated_footing.max_shear_solicitation).to be(true)
    end
  end

  describe '#bending_solicitation' do
    it 'returns the rigth bending moment' do
      max_shear_solicitation = centric_isolated_footing.max_shear_solicitation
      expected_bending_solicitation = 0.25 * max_shear_solicitation * footing.public_send(section_direction)
      expect(centric_isolated_footing.bending_solicitation).to be(expected_bending_solicitation)
    end
  end
end
