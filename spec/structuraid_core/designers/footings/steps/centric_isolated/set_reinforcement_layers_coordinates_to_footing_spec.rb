require 'spec_helper'
require 'byebug'

RSpec.describe StructuraidCore::Designers::Footings::Steps::CentricIsolated::SetReinforcementLayersCoordinatesToFooting do
  describe '.call' do
    subject(:result_with_mocked_required_reinforcement_ratio) { described_class.call(params) }

    let(:params) do
      {
        footing:,
        analysis_direction: :length_1
      }
    end

    let(:ratiostruct) { Struct.new(:computed_ratio, :is_minimum_ratio) }
    let(:analysis_results) { ratiostruct.new(0.0018, true) }

    let(:footing) do
      build(
        :footing,
        length_1: 1500,
        length_2: 1500,
        height:,
        material: build(:concrete, design_compression_strength: 21),
        longitudinal_top_reinforcement_length_1: StructuraidCore::Elements::Reinforcement::StraightLongitudinal.new(
          distribution_direction: :length_2,
          above_middle: true
        ),
        longitudinal_bottom_reinforcement_length_1: StructuraidCore::Elements::Reinforcement::StraightLongitudinal.new(
          distribution_direction: :length_2,
          above_middle: false
        ),
        longitudinal_top_reinforcement_length_2: StructuraidCore::Elements::Reinforcement::StraightLongitudinal.new(
          distribution_direction: :length_1,
          above_middle: true
        ),
        longitudinal_bottom_reinforcement_length_2: StructuraidCore::Elements::Reinforcement::StraightLongitudinal.new(
          distribution_direction: :length_1,
          above_middle: false
        )
      )
    end

    let(:load_location) { build(:absolute_location) }

    let(:height) { 500 }

    let(:load_scenario) do
      build(
        :loads_scenarios_centric_isolated,
        service_load: build(:point_load, value: -112_500, location: load_location),
        ultimate_load: build(:point_load, value: -152_500, location: load_location)
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

    it 'adds start location to context' do
      expect(
        result_with_mocked_required_reinforcement_ratio.reinforcement_layer_start_location
      ).not_to be(nil)
    end

    it 'adds end location to context' do
      expect(
        result_with_mocked_required_reinforcement_ratio.reinforcement_layer_end_location
      ).not_to be(nil)
    end
  end
end
