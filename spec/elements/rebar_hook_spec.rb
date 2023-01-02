require 'spec_helper'
require 'elements/rebar_hook'

RSpec.describe Elements::RebarHook do
  subject(:hook) { described_class.new(number: 18, material: steel) }

  let(:elastic_module) { 200_000 }
  let(:yield_stress) { 420 }
  let(:steel) { Materials::Steel.new(yield_stress:, elastic_module:) }
  let(:diameter) { 6.4 }

  describe '#use_angle_of' do
    describe 'when angle is 90' do
      it "returns the right hook's length" do
        expected_length = 686.4
        expect(hook.use_angle_of(90).round(1)).to eq(expected_length)
      end
    end

    describe 'when angle is 180' do
      it "returns the right hook's length" do
        expected_length = 228.8
        expect(hook.use_angle_of(180).round(1)).to eq(expected_length)
      end
    end

    describe 'when angle is 135' do
      it "returns the right hook's length" do
        expected_length = 343.2
        expect(hook.use_angle_of(135).round(1)).to eq(expected_length)
      end
    end
  end
end
