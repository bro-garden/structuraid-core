require 'spec_helper'
require 'byebug'

RSpec.describe StructuraidCore::Designers::Footings::Steps::CheckMinHeight do
  subject(:result) do
    described_class.call(
      footing:,
      load_scenario:,
      analysis_direction: :length_1,
      design_code: StructuraidCore::DesignCodes::Nsr10,
      support_type:
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

  let(:load_scenario) do
    build(
      :loads_scenarios_centric_isolated,
      service_load: build(:point_load, value: -112_500, location: load_location),
      ultimate_load: build(:point_load, value: -152_500, location: load_location)
    )
  end

  let(:coordinates_system) { build(:coordinates_system) }

  describe '.call' do
    before do
      footing.longitudinal_bottom_reinforcement_length_1.add_layer(
        start_location: build(:relative_location),
        end_location: build(:relative_location),
        amount_of_rebars: 4,
        rebar: build(:rebar)
      )
    end

    describe 'when height is over the minimum' do
      let(:height) { 500 }
      let(:support_type) { :over_piles }

      it 'success' do
        expect(result.success?).to be(true)
      end
    end

    describe 'when support type is not right' do
      let(:height) { 500 }
      let(:support_type) { :not_a_right_type }

      it 'fails' do
        expect(result.success?).to be(false)
      end

      it 'returns a message' do
        expect(result.message).to match('param couldnt be recognized')
      end
    end

    describe 'when height is bellow the minimum' do
      let(:height) { (100..150).to_a.sample }
      let(:support_type) { :over_soil }

      it 'fails' do
        expect(result.success?).to be(false)
      end

      it 'returns a message' do
        expect(result.message).to match('is below')
      end
    end
  end
end
