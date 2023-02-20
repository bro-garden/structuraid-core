require 'spec_helper'
require 'elements/footing'
require 'elements/reinforcement/straight_longitudinal'
require 'materials/concrete'

RSpec.describe Elements::Footing do
  subject(:footing) do
    described_class.new(
      length_1: 2000,
      length_2: 1000,
      height: 400,
      material: concrete,
      cover_lateral: 50,
      cover_top: 50,
      cover_bottom: 75,
      longitudinal_top_reinforcement_length_1:,
      longitudinal_bottom_reinforcement_length_1:,
      longitudinal_top_reinforcement_length_2:,
      longitudinal_bottom_reinforcement_length_2:
    )
  end

  let(:longitudinal_top_reinforcement_length_1) do
    Elements::Reinforcement::StraightLongitudinal.new(z_base: 450, direction: -1, distribution_direction: :length_1)
  end
  let(:longitudinal_top_reinforcement_length_2) do
    Elements::Reinforcement::StraightLongitudinal.new(z_base: 450, direction: -1, distribution_direction: :length_2)
  end
  let(:longitudinal_bottom_reinforcement_length_1) do
    Elements::Reinforcement::StraightLongitudinal.new(z_base: 50, distribution_direction: :length_1)
  end
  let(:longitudinal_bottom_reinforcement_length_2) do
    Elements::Reinforcement::StraightLongitudinal.new(z_base: 50, distribution_direction: :length_2)
  end
  let(:concrete) do
    Materials::Concrete.new(elastic_module: 20_000, design_compression_strength: 20, specific_weight: 24)
  end

  describe '#horizontal_area' do
    it 'returns horizontal area' do
      expect(footing.horizontal_area).to eq(footing.length_1 * footing.length_2)
    end
  end
end
