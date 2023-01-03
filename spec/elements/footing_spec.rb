require 'spec_helper'
require 'elements/footing'
require 'materials/concrete'

RSpec.describe Elements::Footing do
  subject(:footing) { described_class.new(length_x: 100, length_y: 100, height: 100, material: concrete) }

  let(:concrete) do
    Materials::Concrete.new(elastic_module: 20_000, design_compression_strength: 20, specific_weight: 24)
  end

  describe '#horizontal_area' do
    it 'returns horizontal area' do
      expect(footing.horizontal_area).to eq(footing.length_x * footing.length_y)
    end
  end
end
