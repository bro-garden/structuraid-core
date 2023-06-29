require 'spec_helper'
require 'byebug'

RSpec.describe(
  StructuraidCore::Designers::Footings::Steps::CentricIsolated::SetReinforcementLayersCoordinatesToFooting
) do
  describe '.call' do
    subject(:result_with_mocked_required_reinforcement_ratio) { described_class.call(params) }

    let(:params) do
      {
        footing:,
        analysis_direction: :length_1
      }
    end

    let(:footing) do
      build(
        :footing,
        length_1: 1500,
        length_2: 1500,
        height: 500,
        material: build(:concrete, design_compression_strength: 21)
      )
    end

    let(:coordinates_system) { build(:coordinates_system) }

    before do
      footing.add_coordinates_system(coordinates_system)
      footing.add_vertices_location
    end

    it 'is a success' do
      expect(result_with_mocked_required_reinforcement_ratio).to be_a_success
    end

    it "modifies footing by adding a location called 'reinforcement_layer_start_location_length_1_bottom'" do
      expect { result_with_mocked_required_reinforcement_ratio }.to change {
        footing.coordinates_system.find_location('reinforcement_layer_start_location_length_1_bottom').nil?
      }.from(true).to(false)
    end

    it "modifies footing by adding a location called 'reinforcement_layer_end_location_length_1_bottom'" do
      expect { result_with_mocked_required_reinforcement_ratio }.to change {
        footing.coordinates_system.find_location('reinforcement_layer_end_location_length_1_bottom').nil?
      }.from(true).to(false)
    end
  end
end
