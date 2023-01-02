require 'spec_helper'
require './db/base'
require 'elements/rebar'
require 'elements/rebar_hook'

RSpec.describe Elements::Rebar do
  let(:elastic_module) { 200_000 }
  let(:diameter) { 6.4 }
  let(:hooks_class) { Elements::RebarHook }

  describe '.build_by_standard' do
    let(:rebar) { described_class.build_by_standard(number: 18, yield_stress: 420, hooks_class:) }

    it 'returns a Rebar instance' do
      expect(rebar).to be_a(described_class)
    end

    it 'creates a rebar without start hook' do
      expect(rebar.start_hook).to be_nil
    end

    it 'creates a rebar without end hook' do
      expect(rebar.end_hook).to be_nil
    end
  end

  describe '#add_start_hook_of 90' do
    let(:rebar) { described_class.build_by_standard(number: 18, yield_stress: 420, hooks_class:) }

    it 'returns a RebarHook instance' do
      expect(rebar.add_start_hook_of(90)).to be_a(hooks_class)
    end

    it 'adds a start hook' do
      rebar.add_start_hook_of(90)
      expect(rebar.start_hook).to be_a(hooks_class)
    end

    describe '#delete_start_hook' do
      it 'deletes the start hook' do
        rebar.delete_start_hook
        expect(rebar.start_hook).to be_nil
      end
    end
  end

  describe '#add_end_hook_of 90' do
    let(:rebar) { described_class.build_by_standard(number: 18, yield_stress: 420, hooks_class:) }

    it 'returns a RebarHook instance' do
      expect(rebar.add_end_hook_of(90)).to be_a(hooks_class)
    end

    it 'adds a end hook' do
      rebar.add_end_hook_of(90)
      expect(rebar.end_hook).to be_a(hooks_class)
    end

    describe '#delete_end_hook' do
      it 'deletes the end hook' do
        rebar.delete_end_hook
        expect(rebar.end_hook).to be_nil
      end
    end
  end

  describe '#design_yield_stress' do
    describe 'when yield_stress is less than MAX_YIELD_STRESS' do
      let(:rebar) { described_class.new(yield_stress:, elastic_module:, diameter:, hooks_class:) }
      let(:yield_stress) { described_class::MAX_YIELD_STRESS - 100 }

      it 'returns MAX_YIELD_STRESS' do
        expect(rebar.design_yield_stress).to eq(yield_stress)
      end
    end

    describe 'when yield_stress is greater than MAX_YIELD_STRESS' do
      let(:rebar) { described_class.new(yield_stress:, elastic_module:, diameter:, hooks_class:) }
      let(:yield_stress) { described_class::MAX_YIELD_STRESS + 100 }

      it 'returns MAX_YIELD_STRESS' do
        expect(rebar.design_yield_stress).to eq(described_class::MAX_YIELD_STRESS)
      end
    end
  end

  describe '#area' do
    describe 'when diameter is 6.4' do
      let(:rebar) { described_class.new(yield_stress:, elastic_module:, diameter:, hooks_class:) }
      let(:yield_stress) { described_class::MAX_YIELD_STRESS - 100 }

      it 'returns the correct area' do
        area_for_used_diameter = Math::PI * (diameter**2) / 4
        expect(rebar.area).to be(area_for_used_diameter.to_f)
      end
    end
  end

  describe '#perimeter' do
    describe 'when diameter is 6.4' do
      let(:rebar) { described_class.new(yield_stress:, elastic_module:, diameter:, hooks_class:) }
      let(:yield_stress) { described_class::MAX_YIELD_STRESS - 100 }

      it 'returns the correct area' do
        perimeter_for_used_diameter = Math::PI * diameter
        expect(rebar.perimeter).to be(perimeter_for_used_diameter.to_f)
      end
    end
  end
end
