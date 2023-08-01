require 'spec_helper'

RSpec.describe StructuraidCore::Elements::Reinforcement::StraightLongitudinalLayer do
  subject(:straight_longitudinal_layer) do
    described_class.new(
      start_location:,
      end_location:,
      amount_of_rebars:,
      rebar: first_rebar,
      distribution_direction:
    )
  end

  let(:start_location) { build(:relative_location, value_1: -1 * value_1, value_2: -450, value_3:) }
  let(:end_location) { build(:relative_location, value_1:, value_2: 450, value_3:) }
  let(:value_1) { 950 }
  let(:value_3) { 50 }
  let(:amount_of_rebars) { 3 }
  let(:first_rebar) { build(:rebar, number: 3) }

  describe '.new with invalid distribution_direction' do
    let(:distribution_direction) { :length_5 }

    it 'raises error' do
      expect { straight_longitudinal_layer }.to raise_error(
        StructuraidCore::Errors::Reinforcement::InvalidDistributionDirection
      )
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
            straight_longitudinal_layer.instance_variable_get(:@start_location).value_3
          ).to eq(value_3 - first_rebar.diameter * 0.5)
        end

        it 'sets the centroid height of straight_longitudinal_layer at end_location' do
          expect(
            straight_longitudinal_layer.instance_variable_get(:@end_location).value_3
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
            straight_longitudinal_layer.instance_variable_get(:@start_location).value_3
          ).to eq(value_3 - first_rebar.diameter * 0.5 - offset)
        end

        it 'sets the centroid height of straight_longitudinal_layer at end_location' do
          expect(
            straight_longitudinal_layer.instance_variable_get(:@end_location).value_3
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
            straight_longitudinal_layer.instance_variable_get(:@start_location).value_3
          ).to eq(value_3 + first_rebar.diameter * 0.5)
        end

        it 'sets the centroid height of straight_longitudinal_layer at end_location' do
          expect(
            straight_longitudinal_layer.instance_variable_get(:@end_location).value_3
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
            straight_longitudinal_layer.instance_variable_get(:@start_location).value_3
          ).to eq(value_3 + first_rebar.diameter * 0.5 + offset)
        end

        it 'sets the centroid height of straight_longitudinal_layer at end_location' do
          expect(
            straight_longitudinal_layer.instance_variable_get(:@end_location).value_3
          ).to eq(value_3 + first_rebar.diameter * 0.5 + offset)
        end
      end
    end
  end

  describe '#area' do
    let(:distribution_direction) { :length_1 }

    it 'returns the area of the layer' do
      expect(straight_longitudinal_layer.area).to eq(amount_of_rebars * first_rebar.area)
    end
  end

  describe '#diameter' do
    let(:distribution_direction) { :length_1 }

    it 'returns the diameter of the layer' do
      expect(straight_longitudinal_layer.diameter).to eq(first_rebar.diameter)
    end
  end

  describe '#centroid_height' do
    before do
      straight_longitudinal_layer.reposition(above_middle: true)
    end

    let(:distribution_direction) { :length_2 }

    it 'returns the centroid height of the layer' do
      expect(straight_longitudinal_layer.centroid_height).to eq(value_3 - first_rebar.diameter * 0.5)
    end
  end

  describe '#inertia' do
    before do
      straight_longitudinal_layer.reposition(above_middle: true)
    end

    let(:distribution_direction) { :length_1 }

    it 'returns the inertia of the layer' do
      expect(
        straight_longitudinal_layer.inertia
      ).to eq(amount_of_rebars * first_rebar.area * straight_longitudinal_layer.centroid_height)
    end
  end

  describe '#length' do
    before do
      straight_longitudinal_layer.reposition(above_middle: true)
    end

    let(:distribution_direction) { :length_2 }

    it 'returns the length of the layer' do
      expect(straight_longitudinal_layer.length).to eq(2 * value_1)
    end
  end

  describe '#distribution_length' do
    before do
      straight_longitudinal_layer.reposition(above_middle: true)
    end

    let(:distribution_direction) { :length_2 }

    it 'returns the distribution length of the layer' do
      expect(straight_longitudinal_layer.distribution_length).to eq(900)
    end
  end

  describe '#spacing' do
    before do
      straight_longitudinal_layer.reposition(above_middle: true)
    end

    let(:distribution_direction) { :length_2 }

    it 'returns the spacing of the layer' do
      expect(straight_longitudinal_layer.spacing).to eq(450)
    end
  end
end
