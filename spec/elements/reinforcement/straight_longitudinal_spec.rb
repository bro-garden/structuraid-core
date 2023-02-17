require 'spec_helper'
require 'elements/reinforcement/straight_longitudinal'
require 'engineering/locations/relative'
require 'elements/steel_reinforcement/rebar'
require 'materials/steel'

RSpec.describe Elements::Reinforcement::StraightLongitudinal do
  subject(:reinforcement) { described_class.new(z_base: 450, direction: -1) }

  let(:start_location) { Engineering::Locations::Relative.new(value_x: -950, value_y: -450, value_z: 0) }
  let(:end_location) { Engineering::Locations::Relative.new(value_x: 950, value_y: 450, value_z: 0) }

  describe '#add_layout' do
    before do
      reinforcement.add_layout(start_location:, end_location:)
    end

    it 'adds layout' do
      expect(reinforcement.instance_variable_get(:@layouts).size).to eq(1)
    end

    it 'sets the start_location of the layout' do
      expect(reinforcement.instance_variable_get(:@layouts).first.start_location).to eq(start_location)
    end

    it 'sets the end_location of the layout' do
      expect(reinforcement.instance_variable_get(:@layouts).first.end_location).to eq(end_location)
    end
  end

  describe '#modify_z_base' do
    describe 'when there is no layouts' do
      before do
        reinforcement.modify_z_base(z_base: 500)
      end

      it 'updates z_base property' do
        expect(reinforcement.instance_variable_get(:@z_base)).to eq(500)
      end

      it 'keeps layouts empty' do
        expect(reinforcement.instance_variable_get(:@layouts)).to be_empty
      end
    end

    describe 'when there are layouts' do
      before do
        reinforcement.add_layout(start_location:, end_location:)
        reinforcement.modify_z_base(z_base: 500)
      end

      it 'updates z_base property' do
        expect(reinforcement.instance_variable_get(:@z_base)).to eq(500)
      end

      it 'updates value_z at start_location of layouts' do
        expect(reinforcement.instance_variable_get(:@layouts).first.start_location.value_z).to eq(500)
      end

      it 'updates value_z at end_location of layouts' do
        expect(reinforcement.instance_variable_get(:@layouts).first.end_location.value_z).to eq(500)
      end
    end
  end

  describe '#add' do
    let(:rebar) do
      Elements::SteelReinforcement::Rebar.new(
        number: 3,
        material: Materials::Steel.new(yield_stress: 4200)
      )
    end

    before do
      reinforcement.add_layout(start_location:, end_location:)
      reinforcement.add(number_of_rebars: 10, rebar:, length: 900)
    end

    it 'adds rebar' do
      expect(reinforcement.instance_variable_get(:@layouts).first.rebar).to eq(rebar)
    end
  end

  describe '#change' do
    let(:material) { Materials::Steel.new(yield_stress: 4200) }
    let(:first_rebar) do
      Elements::SteelReinforcement::Rebar.new(
        number: 3,
        material:
      )
    end
    let(:rebar_changed) do
      Elements::SteelReinforcement::Rebar.new(
        number: 5,
        material:
      )
    end

    before do
      reinforcement.add_layout(start_location:, end_location:)
      reinforcement.add(number_of_rebars: 10, rebar: first_rebar, length: 900)
    end

    it 'changes rebar' do
      id_of_layout_to_change = reinforcement.instance_variable_get(:@layouts).first.id
      reinforcement.change(id_of_layout_to_change:, number_of_rebars: 15, rebar: rebar_changed, length: 900)
      expect(reinforcement.instance_variable_get(:@layouts).first.rebar).to eq(rebar_changed)
    end
  end
end
