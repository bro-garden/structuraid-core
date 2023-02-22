require 'spec_helper'
require 'elements/reinforcement/straight_longitudinal'
require 'engineering/locations/relative'
require 'elements/reinforcement/rebar'
require 'materials/steel'

RSpec.describe Elements::Reinforcement::StraightLongitudinal do
  subject(:reinforcement) { described_class.new(distribution_direction: :length_1) }

  let(:start_location) { Engineering::Locations::Relative.new(value_1: -950, value_2: -450, value_3: cover_bottom) }
  let(:cover_bottom) { 50 }
  let(:end_location) { Engineering::Locations::Relative.new(value_1: 950, value_2: 450, value_3: cover_bottom) }
  let(:material) { Materials::Steel.new(yield_stress: 4200) }
  let(:first_rebar) do
    Elements::Reinforcement::Rebar.new(
      number: 3,
      material:
    )
  end

  describe '#add_layer' do
    before do
      reinforcement.add_layer(start_location:, end_location:, amount_of_rebars: 5, rebar: first_rebar)
    end

    let(:expected_centroid_height_of_layer) { cover_bottom + first_rebar.diameter * 0.5 }

    it 'adds straight_longitudinal_layer' do
      expect(reinforcement.instance_variable_get(:@layers).size).to eq(1)
    end

    it 'sets the centroid height of straight_longitudinal_layer at start_location' do
      expect(
        reinforcement.instance_variable_get(:@layers).first.start_location.value_3
      ).to eq(expected_centroid_height_of_layer)
    end

    it 'sets the centroid height of straight_longitudinal_layer at end_location' do
      expect(
        reinforcement.instance_variable_get(:@layers).first.end_location.value_3
      ).to eq(expected_centroid_height_of_layer)
    end
  end

  # describe '#change' do
  #   let(:rebar_changed) do
  #     Elements::Reinforcement::Rebar.new(
  #       number: 5,
  #       material:
  #     )
  #   end

  #   before do
  #     reinforcement.add_layer(start_location:, end_location:, number_of_rebars: 5, rebar: first_rebar)
  #     id_of_layer_to_change = reinforcement.instance_variable_get(:@layers).first.id
  #     reinforcement.change(
  #       id_of_layer_to_change:,
  #       number_of_rebars: 10,
  #       rebar: rebar_changed
  #     )
  #   end

  #   it 'changes rebar' do
  #     expect(reinforcement.instance_variable_get(:@layers).first.rebar).to eq(rebar_changed)
  #   end
  # end
end
