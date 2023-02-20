require 'spec_helper'
require 'elements/reinforcement/straight_longitudinal'
require 'engineering/locations/relative'
require 'elements/reinforcement/rebar'
require 'materials/steel'

RSpec.describe Elements::Reinforcement::StraightLongitudinal do
  subject(:reinforcement) { described_class.new(z_base: 450, direction: -1, distribution_direction: :length_1) }

  let(:start_location) { Engineering::Locations::Relative.new(value_1: -950, value_2: -450, value_3: 0) }
  let(:end_location) { Engineering::Locations::Relative.new(value_1: 950, value_2: 450, value_3: 0) }
  let(:material) { Materials::Steel.new(yield_stress: 4200) }
  let(:first_rebar) do
    Elements::Reinforcement::Rebar.new(
      number: 3,
      material:
    )
  end

  describe '#add_layer' do
    before do
      reinforcement.add_layer(start_location:, end_location:, number_of_rebars: 5, rebar: first_rebar)
    end

    it 'adds straight_longitudinal_layer' do
      expect(reinforcement.instance_variable_get(:@layers).size).to eq(1)
    end

    it 'sets the start_location of the straight_longitudinal_layer' do
      expect(reinforcement.instance_variable_get(:@layers).first.start_location).to eq(start_location)
    end

    it 'sets the end_location of the straight_longitudinal_layer' do
      expect(reinforcement.instance_variable_get(:@layers).first.end_location).to eq(end_location)
    end
  end

  describe '#modify_z_base' do
    describe 'when there is no straight_longitudinal_layers' do
      before do
        reinforcement.modify_z_base(z_base: 500)
      end

      it 'updates z_base property' do
        expect(reinforcement.instance_variable_get(:@z_base)).to eq(500)
      end

      it 'keeps straight_longitudinal_layers empty' do
        expect(reinforcement.instance_variable_get(:@layers)).to be_empty
      end
    end

    describe 'when there are straight_longitudinal_layers' do
      before do
        reinforcement.add_layer(start_location:, end_location:, number_of_rebars: 5, rebar: first_rebar)
        reinforcement.modify_z_base(z_base: 500)
      end

      it 'updates z_base property' do
        expect(reinforcement.instance_variable_get(:@z_base)).to eq(500)
      end

      it 'updates value_z at start_location of straight_longitudinal_layers' do
        expect(reinforcement.instance_variable_get(:@layers).first.start_location.value_3).to eq(500)
      end

      it 'updates value_z at end_location of straight_longitudinal_layers' do
        expect(reinforcement.instance_variable_get(:@layers).first.end_location.value_3).to eq(500)
      end
    end
  end

  describe '#change' do
    let(:rebar_changed) do
      Elements::Reinforcement::Rebar.new(
        number: 5,
        material:
      )
    end

    before do
      reinforcement.add_layer(start_location:, end_location:, number_of_rebars: 5, rebar: first_rebar)
      id_of_layer_to_change = reinforcement.instance_variable_get(:@layers).first.id
      reinforcement.change(
        id_of_layer_to_change:,
        number_of_rebars: 10,
        rebar: rebar_changed
      )
    end

    it 'changes rebar' do
      expect(reinforcement.instance_variable_get(:@layers).first.rebar).to eq(rebar_changed)
    end
  end
end
