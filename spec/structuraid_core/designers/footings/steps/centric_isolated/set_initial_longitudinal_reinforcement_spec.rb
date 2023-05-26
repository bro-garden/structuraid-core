require 'spec_helper'
require 'byebug'

RSpec.describe StructuraidCore::Designers::Footings::Steps::CentricIsolated::SetInitialLongitudinalReinforcement do
  describe '.call' do
    subject(:result_with_mocked_required_reinforcement_ratio) do
      described_class.call(
        footing:,
        load_scenario:,
        analysis_direction: :length_1,
        design_code: StructuraidCore::DesignCodes::Nsr10,
        steel: build(:steel),
        analysis_results: { required_reinforcement_ratio: 0.0025 }
      )
    end

    let(:footing) do
      build(
        :footing,
        length_1: 1500,
        length_2: 1500,
        height:,
        material: build(:concrete, design_compression_strength: 21),
        longitudinal_top_reinforcement_length_1: StructuraidCore::Elements::Reinforcement::StraightLongitudinal.new(
          distribution_direction: :length_1,
          above_middle: true
        ),
        longitudinal_bottom_reinforcement_length_1: StructuraidCore::Elements::Reinforcement::StraightLongitudinal.new(
          distribution_direction: :length_1,
          above_middle: false
        ),
        longitudinal_top_reinforcement_length_2: StructuraidCore::Elements::Reinforcement::StraightLongitudinal.new(
          distribution_direction: :length_2,
          above_middle: true
        ),
        longitudinal_bottom_reinforcement_length_2: StructuraidCore::Elements::Reinforcement::StraightLongitudinal.new(
          distribution_direction: :length_2,
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

    it 'modifies footing by adding reinforcement layer' do
      expect { result_with_mocked_required_reinforcement_ratio }.to change {
        footing.reinforcement(direction: :length_1, above_middle: false).empty?
      }.from(true).to(false)
    end
  end
end
