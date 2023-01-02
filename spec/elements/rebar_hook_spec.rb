require 'spec_helper'
require 'elements/rebar_hook'

RSpec.describe Elements::RebarHook do
  let(:diameter) { 6.4 }
  let(:hook) { described_class.new(yield_stress: 420, elastic_module: 200_000) }

  describe '#setup_properties' do
    describe 'when diameter is 6.4 and angle is 90' do
      it "returns the right hook's length" do
        expect(hook.setup_properties(diameter, 90).round(1)).to eq(76.8)
      end
    end
  end

  describe '#use_angle_of' do
    before do
      hook.setup_properties(diameter, 0)
    end

    describe 'when angle is 90' do
      it "returns the right hook's length" do
        expect(hook.use_angle_of(90).round(1)).to eq(76.8)
      end
    end

    describe 'when angle is 180' do
      it "returns the right hook's length" do
        expect(hook.use_angle_of(180).round(1)).to eq(60.0)
      end
    end

    describe 'when angle is 135' do
      it "returns the right hook's length" do
        expect(hook.use_angle_of(135).round(1)).to eq(75.0)
      end
    end
  end
end
