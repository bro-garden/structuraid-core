require 'spec_helper'
require 'elements/footing'
require 'materials/concrete'

RSpec.describe Elements::Footing do
  subject(:footing) { described_class.new(dimension1: 100, dimension2: 100, height: 100, concrete:) }

  let(:concrete) { Materials::Concrete.new_reinfoced_concrete(elastic_module: 20_000, design_compression_strength: 20) }

  describe '#change_concrete_to' do
    let(:concrete2) { Materials::Concrete.new_reinfoced_concrete(elastic_module: 20_000, design_compression_strength: 24) }

    it 'changes concrete' do
      footing.change_concrete_to(concrete2)

      expect(footing.concrete).to eq(concrete2)
    end
  end

  describe '#incrase_height_by_step' do
    it 'increases height by step' do
      initial_height = footing.height
      footing.incrase_height_by_step

      expect(footing.height).to eq(initial_height + footing.step)
    end
  end

  describe '#incrase_dimension1_by_step' do
    it 'increases dimension1 by step' do
      initial_dimension1 = footing.dimension1
      footing.incrase_dimension1_by_step

      expect(footing.dimension1).to eq(initial_dimension1 + footing.step)
    end
  end

  describe '#incrase_dimension2_by_step' do
    it 'increases dimension2 by step' do
      initial_dimension2 = footing.dimension2
      footing.incrase_dimension2_by_step

      expect(footing.dimension2).to eq(initial_dimension2 + footing.step)
    end
  end

  describe '#area' do
    it 'returns area' do
      expect(footing.area).to eq(footing.dimension1 * footing.dimension2)
    end
  end
end
