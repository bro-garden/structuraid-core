require 'spec_helper'
require 'elements/reinforcement/straight_longitudinal'
require 'engineering/locations/relative'

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
end
