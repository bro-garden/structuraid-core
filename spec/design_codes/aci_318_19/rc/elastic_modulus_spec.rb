require 'spec_helper'
require 'design_codes/aci_318_19/rc/elastic_modulus'
require 'errors/design_codes/missing_param_error'

# rubocop:disable RSpec/FilePath
RSpec.describe DesignCodes::ACI31819::RC::ElasticModulus do
  describe '.call' do
    subject(:result) { described_class.call(design_compression_strength:) }

    let(:design_compression_strength) { 28 }

    it 'returns the elastic module' do
      expect(result.round).to eq(24_870)
    end

    describe 'when compression strength is not passed' do
      let(:design_compression_strength) { nil }

      it 'raises an error' do
        expect { result }.to raise_error(DesignCodes::MissingParamError)
      end
    end
  end
end
# rubocop:enable RSpec/FilePath
