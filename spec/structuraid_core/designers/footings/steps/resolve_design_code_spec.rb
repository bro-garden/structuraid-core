require 'spec_helper'

RSpec.describe StructuraidCore::Designers::Footings::Steps::ResolveDesignCode do
  describe '.call' do
    subject(:context) { described_class.call(design_code:) }

    let(:design_code) { 'nsr_10' }

    before do
      context
    end

    it 'succeeds' do
      expect(context.success?).to eq(true)
    end

    it 'sets the design code' do
      expect(context.design_code).to eq(StructuraidCore::DesignCodes::NSR10)
    end

    context 'when the design code is not found' do
      let(:design_code) { 'foo' }

      it 'fails' do
        expect(context.failure?).to eq(true)
      end

      it 'sets the error message' do
        expect(context.message).to match('Design code foo is unknown')
      end
    end
  end
end
