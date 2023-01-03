require 'spec_helper'
require 'db/base'
require 'elements/steel_reinforcement/rebar'
require 'elements/steel_reinforcement/rebar_hook'
require 'materials/steel'

RSpec.describe Elements::SteelReinforcement::Rebar do
  let(:elastic_module) { 200_000 }
  let(:yield_stress) { 420 }
  let(:steel) { Materials::Steel.new(yield_stress:, elastic_module:) }
  let(:diameter) { 6.4 }
  let(:number) { 18 }

  describe '.build_by_standard' do
    let(:rebar) { described_class.new(number:, material: steel, standard_bars: DB::Base) }

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

  describe '#add_start_hook 90' do
    let(:rebar) { described_class.new(number:, material: steel, standard_bars: DB::Base) }
    let(:hook) { Elements::SteelReinforcement::RebarHook.new(number:, material: steel, standard_bars: DB::Base) }

    it 'returns a RebarHook instance' do
      expect(rebar.add_start_hook(hook, 90)).to be_a(Elements::SteelReinforcement::RebarHook)
    end

    it 'adds a start hook' do
      rebar.add_start_hook(hook, 90)
      expect(rebar.start_hook).to be_a(Elements::SteelReinforcement::RebarHook)
    end

    describe '#delete_start_hook' do
      it 'deletes the start hook' do
        rebar.delete_start_hook
        expect(rebar.start_hook).to be_nil
      end
    end
  end

  describe '#add_end_hook 90' do
    let(:rebar) { described_class.new(number:, material: steel, standard_bars: DB::Base) }
    let(:hook) { Elements::SteelReinforcement::RebarHook.new(number:, material: steel, standard_bars: DB::Base) }

    it 'returns a RebarHook instance' do
      expect(rebar.add_end_hook(hook, 90)).to be_a(Elements::SteelReinforcement::RebarHook)
    end

    it 'adds a start hook' do
      rebar.add_end_hook(hook, 90)
      expect(rebar.end_hook).to be_a(Elements::SteelReinforcement::RebarHook)
    end

    describe '#delete_end_hook' do
      it 'deletes the start hook' do
        rebar.delete_end_hook
        expect(rebar.end_hook).to be_nil
      end
    end
  end

  describe '#area' do
    let(:rebar) { described_class.new(number:, material: steel, standard_bars: DB::Base) }

    it 'returns the correct area' do
      diameter = rebar.diameter
      area_for_used_diameter = Math::PI * (diameter**2) / 4
      expect(rebar.area).to be(area_for_used_diameter.to_f)
    end
  end

  describe '#perimeter' do
    let(:rebar) { described_class.new(number:, material: steel, standard_bars: DB::Base) }

    it 'returns the correct area' do
      diameter = rebar.diameter
      perimeter_for_used_diameter = Math::PI * diameter
      expect(rebar.perimeter).to be(perimeter_for_used_diameter.to_f)
    end
  end
end
