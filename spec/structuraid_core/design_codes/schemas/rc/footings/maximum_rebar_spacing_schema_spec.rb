require 'spec_helper'

RSpec.describe StructuraidCore::DesignCodes::Schemas::Rc::Footings::MaximumRebarSpacingSchema do
  let(:params) do
    {
      support_type: :over_soil,
      footing_height: 250,
      for_min_rebar: false,
      yield_stress: 420,
      reinforcement_cover: 75
    }
  end

  let(:members_array) do
    %i[
      schema
      support_type
      footing_height
      for_min_rebar
      yield_stress
      reinforcement_cover
    ]
  end

  describe '.validate!' do
    subject(:result) { described_class.validate!(params) }

    it 'returns true' do
      expect(result).to eq(true)
    end

    describe 'when required param is missing' do
      let(:params) { {} }

      it 'raises an error' do
        expect { result }.to raise_error(StructuraidCore::Errors::DesignCodes::MissingParamError)
      end
    end
  end

  describe '.structurize' do
    subject(:result) { described_class.structurize(params) }

    it 'returns a struct with the required param' do
      expect(result.members).to match_array(members_array)
    end
  end
end
