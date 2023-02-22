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
  let(:rebar_changed) do
    Elements::Reinforcement::Rebar.new(
      number: 8,
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

  describe '#change_layer_rebar_configuration' do
    before do
      reinforcement.add_layer(start_location:, end_location:, amount_of_rebars: 5, rebar: first_rebar)
      reinforcement.change_layer_rebar_configuration(
        layer_id: reinforcement.instance_variable_get(:@layers).first.id,
        amount_of_new_rebars: 5,
        new_rebar: rebar_changed
      )
    end

    it "updates selected layer's rebar" do
      expect(reinforcement.instance_variable_get(:@layers).first.rebar).to eq(rebar_changed)
    end

    it "updates selected layer's centroid height" do
      expected_centroid_height_of_layer = cover_bottom + rebar_changed.diameter * 0.5
      expect(
        reinforcement.instance_variable_get(:@layers).first.start_location.value_3
      ).to eq(expected_centroid_height_of_layer)
    end
  end

  describe '#move_layer_by_its_axis_3' do
    before do
      reinforcement.add_layer(start_location:, end_location:, amount_of_rebars: 5, rebar: first_rebar)
      reinforcement.move_layer_by_its_axis_3(
        layer_id: reinforcement.instance_variable_get(:@layers).first.id,
        offset: 100
      )
    end

    it "updates selected layer's centroid height" do
      expected_centroid_height_of_layer = cover_bottom + first_rebar.diameter * 0.5 + 100
      expect(
        reinforcement.instance_variable_get(:@layers).first.start_location.value_3
      ).to eq(expected_centroid_height_of_layer)
    end
  end

  describe '#area' do
    before do
      reinforcement.add_layer(
        start_location:,
        end_location:,
        amount_of_rebars: amount_of_first_rebar,
        rebar: first_rebar
      )
      reinforcement.add_layer(
        start_location:,
        end_location:,
        amount_of_rebars: amount_of_changed_rebar,
        rebar: rebar_changed
      )
    end

    let(:amount_of_first_rebar) { 3 }
    let(:amount_of_changed_rebar) { 5 }

    it 'returns the total area of all layers' do
      expect(reinforcement.area).to eq(
        amount_of_changed_rebar * rebar_changed.area + amount_of_first_rebar * first_rebar.area
      )
    end
  end
end
