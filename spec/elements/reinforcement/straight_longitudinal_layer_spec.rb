require 'spec_helper'
require 'elements/reinforcement/straight_longitudinal_layer'
require 'engineering/locations/relative'
require 'elements/reinforcement/rebar'
require 'materials/steel'

RSpec.describe Elements::Reinforcement::StraightLongitudinalLayer do
  subject(:straight_longitudinal_layer) do
    described_class.new(
      start_location:,
      end_location:,
      amount_of_rebars:,
      rebar: first_rebar,
      id:,
      distribution_direction:
    )
  end

  let(:start_location) { Engineering::Locations::Relative.new(value_1: -950, value_2: -450, value_3:) }
  let(:end_location) { Engineering::Locations::Relative.new(value_1: 950, value_2: 450, value_3:) }
  let(:value_3) { 50 }
  let(:amount_of_rebars) { 3 }
  let(:material) { Materials::Steel.new(yield_stress: 4200) }
  let(:id) { 1 }
  let(:first_rebar) do
    Elements::Reinforcement::Rebar.new(
      number: 3,
      material:
    )
  end

  describe '.new with wrong distribution_direction' do
    let(:distribution_direction) { :length_5 }

    it 'raises error' do
      expect { straight_longitudinal_layer }.to raise_error(Elements::Reinforcement::InvalidDistributionDirection)
    end
  end

  describe '#reposition' do
    let(:distribution_direction) { :length_2 }

    describe 'when above_middle = true' do
      describe 'when is used to fix the layer to the rebar centroid' do
        before do
          straight_longitudinal_layer.reposition(above_middle: true)
        end

        it 'sets the centroid height of straight_longitudinal_layer at start_location' do
          expect(
            straight_longitudinal_layer.start_location.value_3
          ).to eq(value_3 - first_rebar.diameter * 0.5)
        end

        it 'sets the centroid height of straight_longitudinal_layer at end_location' do
          expect(
            straight_longitudinal_layer.end_location.value_3
          ).to eq(value_3 - first_rebar.diameter * 0.5)
        end
      end

      describe 'when is used to move the layer' do
        before do
          straight_longitudinal_layer.reposition(above_middle: true)
          straight_longitudinal_layer.reposition(above_middle: true, offset:)
        end

        let(:offset) { 10 }

        it 'sets the centroid height of straight_longitudinal_layer at start_location' do
          expect(
            straight_longitudinal_layer.start_location.value_3
          ).to eq(value_3 - first_rebar.diameter * 0.5 - offset)
        end

        it 'sets the centroid height of straight_longitudinal_layer at end_location' do
          expect(
            straight_longitudinal_layer.end_location.value_3
          ).to eq(value_3 - first_rebar.diameter * 0.5 - offset)
        end
      end
    end

    describe 'when above_middle = false' do
      describe 'when is used to fix the layer to the rebar centroid' do
        before do
          straight_longitudinal_layer.reposition(above_middle: false)
        end

        it 'sets the centroid height of straight_longitudinal_layer at start_location' do
          expect(
            straight_longitudinal_layer.start_location.value_3
          ).to eq(value_3 + first_rebar.diameter * 0.5)
        end

        it 'sets the centroid height of straight_longitudinal_layer at end_location' do
          expect(
            straight_longitudinal_layer.end_location.value_3
          ).to eq(value_3 + first_rebar.diameter * 0.5)
        end
      end

      describe 'when is used to move the layer' do
        before do
          straight_longitudinal_layer.reposition(above_middle: false)
          straight_longitudinal_layer.reposition(above_middle: false, offset:)
        end

        let(:offset) { 10 }

        it 'sets the centroid height of straight_longitudinal_layer at start_location' do
          expect(
            straight_longitudinal_layer.start_location.value_3
          ).to eq(value_3 + first_rebar.diameter * 0.5 + offset)
        end

        it 'sets the centroid height of straight_longitudinal_layer at end_location' do
          expect(
            straight_longitudinal_layer.end_location.value_3
          ).to eq(value_3 + first_rebar.diameter * 0.5 + offset)
        end
      end
    end
  end
end
