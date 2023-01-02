require 'spec_helper'
require './db/base'
require 'elements/rebar'
require 'byebug'

RSpec.describe Elements::Rebar do
  let(:elastic_module) { 200_000 }
  let(:diameter) { 6.4 }

  describe '.build_by_standard' do
    let(:rebar) { described_class.build_by_standard(number: 18, yield_stress: 420) }

    it 'returns a Rebar instance' do
      expect(rebar).to be_a(described_class)
    end
  end

  describe '#design_yield_stress' do
    describe 'when yield_stress is less than MAX_YIELD_STRESS' do
      let(:rebar) { described_class.new(yield_stress:, elastic_module:, diameter:) }
      let(:yield_stress) { described_class::MAX_YIELD_STRESS - 100 }

      it 'returns MAX_YIELD_STRESS' do
        expect(rebar.design_yield_stress).to eq(yield_stress)
      end
    end

    describe 'when yield_stress is greater than MAX_YIELD_STRESS' do
      let(:rebar) { described_class.new(yield_stress:, elastic_module:, diameter:) }
      let(:yield_stress) { described_class::MAX_YIELD_STRESS + 100 }

      it 'returns MAX_YIELD_STRESS' do
        expect(rebar.design_yield_stress).to eq(described_class::MAX_YIELD_STRESS)
      end
    end
  end

  describe '#area' do
    describe 'when diameter is 6.4' do
      let(:rebar) { described_class.new(yield_stress:, elastic_module:, diameter:) }
      let(:yield_stress) { described_class::MAX_YIELD_STRESS - 100 }

      it 'returns the correct area' do
        area_for_used_diameter = Math::PI * (diameter**2) / 4
        expect(rebar.area).to be(area_for_used_diameter.to_f)
      end
    end
  end

  describe '#perimeter' do
    describe 'when diameter is 6.4' do
      let(:rebar) { described_class.new(yield_stress:, elastic_module:, diameter:) }
      let(:yield_stress) { described_class::MAX_YIELD_STRESS - 100 }

      it 'returns the correct area' do
        perimeter_for_used_diameter = Math::PI * diameter
        expect(rebar.perimeter).to be(perimeter_for_used_diameter.to_f)
      end
    end
  end
end
