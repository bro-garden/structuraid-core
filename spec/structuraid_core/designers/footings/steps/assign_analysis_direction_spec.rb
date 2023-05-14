require 'spec_helper'

RSpec.describe StructuraidCore::Designers::Footings::Steps::AssignAnalysisDirection do
  describe '.call' do
    subject(:result) { described_class.call(analysis_length_1:, analysis_length_2:) }

    let(:analysis_length_1) { nil }
    let(:analysis_length_2) { nil }

    it 'is a success' do
      expect(result).to be_a_success
    end

    it 'assigns the analysis direction to length_1' do
      expect(result.analysis_direction).to eq(:length_1)
    end

    describe 'when analysis_length_1 is true' do
      let(:analysis_length_1) { true }

      it 'assigns the analysis direction to length_2' do
        expect(result.analysis_direction).to eq(:length_2)
      end
    end

    describe 'when analysis_length_2 and analysis_length_1 are true' do
      let(:analysis_length_2) { true }
      let(:analysis_length_1) { true }

      it 'is a failure' do
        expect(result).to be_a_failure
      end

      it 'delivers a message' do
        expect(result.message).to match('Analysis has been run for all directions already')
      end
    end
  end
end
