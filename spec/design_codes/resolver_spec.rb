require 'spec_helper'
require 'design_codes/resolver'
require 'errors/design_codes/unknown_design_code_error'

RSpec.describe DesignCodes::Resolver do
  describe '.use' do
    subject(:code) { described_class.use(code_name) }

    let(:code_name) { 'nsr_10' }

    it 'returns the NSR-10 module' do
      expect(code).to eq(DesignCodes::NSR10)
    end

    describe 'when code doesnt exist' do
      let(:code_name) { 'super_code' }

      it 'raises an error' do
        expect { code }.to raise_error(DesignCodes::UnknownDesignCodeError)
      end
    end
  end
end
