require 'spec_helper'
require 'engineering/analysis/footing/centric_isolated'
require 'elements/r_c/column/rectangular'
require 'elements/footing'
require 'loads/point_load'
require 'byebug'

RSpec.describe Engineering::Analysis::Footing::CentricIsolated do
  let(:column) do
    Elements::RC::Column::Rectangular.new(length_x: 500, length_y: 300, height: 2900, material: 'concrete')
  end
  let(:footing) do
    Elements::Footing.new(length_x: 4000, length_y: 4000, height: 400, material: 'concrete')
  end
  let(:load_from_column) { Loads::PointLoad.new(value: 1500, location: nil) }
  let(:effective_height) { 250 }
  let(:cut_direction) { :length_x }

  describe 'when create an instance with a worong cut_direction' do
    # let(:wrong_instance) do
    #   described_class.new(column:, footing:, effective_height:, load_from_column:, cut_direction: wrong_cut_direction)
    # end
    let(:wrong_cut_direction) { :length_z }

    it 'returns an error' do
      byebug
      expect(described_class.new(column:, footing:, effective_height:, load_from_column:,
                                 cut_direction: wrong_cut_direction)).to raise_error(ArgumentError)
    end
  end

  # subject(:analysis) do
  #   described_class.new(
  #     column: column,
  #     footing: footing,
  #     effective_height: effective_height,
  #     load_from_column: load_from_column,
  #     cut_direction: cut_direction
  #   )
  # end
end
