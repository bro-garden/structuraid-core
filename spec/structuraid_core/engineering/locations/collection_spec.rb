require 'spec_helper'
require 'structuraid_core/errors/engineering/locations/duplicate_label_error'

RSpec.describe StructuraidCore::Engineering::Locations::Collection do
  subject(:collection) { described_class.new }

  let(:location) do
    StructuraidCore::Engineering::Locations::Relative.new(value_1: 1, value_2: 2, value_3: 3, label:)
  end

  let(:label) { :label }

  describe '#each' do
    before do
      collection.add(location)
    end

    it 'yields each location' do
      expect { |b| collection.each(&b) }.to yield_with_args(location)
    end
  end

  describe '#inspect' do
    before do
      collection.add(location)
    end

    it 'returns a string' do
      expect(collection.inspect).to eq("[#{location.inspect}]")
    end
  end

  describe '#find_by_label' do
    before do
      collection.add(location)
    end

    it 'returns the location with the given label' do
      expect(collection.find_by_label(label)).to eq(location)
    end

    describe 'when the label does not exist' do
      let(:non_existent_label) { :non_existent_label }

      it 'returns nil' do
        expect(collection.find_by_label(non_existent_label)).to be_nil
      end
    end
  end

  describe '#add' do
    before do
      collection.add(location)
    end

    it 'adds a location to the collection' do
      expect(collection).to include(location)
    end

    describe 'when the location has a label that already exists' do
      let(:new_location) do
        StructuraidCore::Engineering::Locations::Relative.new(value_1: 5, value_2: 7, value_3: 8, label:)
      end

      it 'adds a location to the collection' do
        expect { collection.add(new_location) }.to raise_error(
          StructuraidCore::Engineering::Locations::DuplicateLabelError
        )
      end
    end
  end

  describe '#find_or_add_by_label' do
    subject(:result) { collection.find_or_add_by_label(location) }

    let(:location) do
      StructuraidCore::Engineering::Locations::Relative.new(value_1: 10, value_2: 20, value_3: 10, label: :label)
    end

    it 'adds the location to the collection' do
      expect { result }.to change { collection.find_by_label(:label) }.from(nil).to(anything)
    end

    it 'returns the added location' do
      expect(result.to_vector).to eq(Vector[10, 20, 10])
    end

    describe 'when location is already present' do
      let(:existing_location) { location.dup }

      before do
        collection.add(location)
      end

      it 'returns the existing location' do
        expect(collection.find_or_add_by_label(existing_location)).to eq(location)
      end
    end
  end
end
