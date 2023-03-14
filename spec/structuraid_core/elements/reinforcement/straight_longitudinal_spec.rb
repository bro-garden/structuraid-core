require 'spec_helper'

RSpec.describe StructuraidCore::Elements::Reinforcement::StraightLongitudinal do
  subject(:reinforcement) { described_class.new(distribution_direction: :length_1) }

  let(:start_location) { StructuraidCore::Engineering::Locations::Relative.new(value_1: -950, value_2: -450, value_3: cover_bottom) }
  let(:cover_bottom) { 50 }
  let(:end_location) { StructuraidCore::Engineering::Locations::Relative.new(value_1: 950, value_2: 450, value_3: cover_bottom) }
  let(:material) { StructuraidCore::Materials::Steel.new(yield_stress: 4200) }
  let(:first_rebar) do
    StructuraidCore::Elements::Reinforcement::Rebar.new(
      number: 3,
      material:
    )
  end
  let(:rebar_changed) do
    StructuraidCore::Elements::Reinforcement::Rebar.new(
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
        reinforcement.instance_variable_get(:@layers).first.instance_variable_get(:@start_location).value_3
      ).to eq(expected_centroid_height_of_layer)
    end

    it 'sets the centroid height of straight_longitudinal_layer at end_location' do
      expect(
        reinforcement.instance_variable_get(:@layers).first.instance_variable_get(:@end_location).value_3
      ).to eq(expected_centroid_height_of_layer)
    end
  end

  describe '#centroid_height' do
    describe 'when there are no layers added' do
      it 'raises error' do
        expect { reinforcement.centroid_height }.to raise_error(StructuraidCore::Elements::Reinforcement::EmptyLayers)
      end
    end

    describe 'when there are layers added' do
      before do
        reinforcement.add_layer(start_location:, end_location:, amount_of_rebars: 5, rebar: first_rebar)
      end

      let(:expected_centroid_height) { cover_bottom + first_rebar.diameter * 0.5 }

      it 'returns the centroid height of all layers' do
        expect(reinforcement.centroid_height).to eq(expected_centroid_height)
      end
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
