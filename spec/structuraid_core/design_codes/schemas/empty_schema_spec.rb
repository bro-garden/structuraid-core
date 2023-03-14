require 'spec_helper'

RSpec.describe StructuraidCore::DesignCodes::Schemas::EmptySchema do
  describe '.validate!' do
    subject(:result) { described_class.validate!(params) }

    let(:params) { {} }

    it 'returns true' do
      expect(result).to eq(true)
    end
  end

  describe '.structurize' do
    subject(:result) { described_class.structurize(params) }

    let(:params) { { a: 1 } }

    it 'returns a struct with the schema name only' do
      expect(result.members).to eq([:schema])
    end
  end
end
