require 'spec_helper'
require 'matrix'
require 'byebug'

RSpec.describe StructuraidCore::Optimization::RebarWithConstantLength do
  subject(:optimizator) do
    described_class.new(
      required_reinforcement_area,
      maximum_rebar_spacing,
      space_to_cover
    )
  end

  let(:maximum_rebar_spacing) { 150 }
  let(:space_to_cover) { 5_000 }

  describe 'with casual required_reinforcement_area' do
    let(:required_reinforcement_area) { 10_000 }

    describe '#run' do
      it 'returns rsult_code 0' do
        expect(optimizator.run.result_code).to eq(
          StructuraidCore::Optimization::RebarWithConstantLength::SUCCESSFUL_RESULT_CODE
        )
      end

      it 'returns a Result struct object' do
        expect(optimizator.run).to be_an_instance_of(
          StructuraidCore::Optimization::RebarWithConstantLength::Result
        )
      end

      it 'returns a value at :rebar key' do
        expect(optimizator.run.rebar).not_to be(nil)
      end

      it 'returns a value at :amount_of_rebars key' do
        expect(optimizator.run.amount_of_rebars).not_to be(nil)
      end
    end

    describe '#log' do
      before { optimizator.run }

      it 'returns an Array object' do
        expect(optimizator.log).to be_an_instance_of(Array)
      end
    end
  end

  describe 'with small required_reinforcement_area' do
    let(:required_reinforcement_area) { 120 }

    describe '#run' do
      it 'returns the right result_code' do
        expect(optimizator.run.result_code).to eq(
          StructuraidCore::Optimization::RebarWithConstantLength::UNSUCCESSFUL_RESULT_CODE
        )
      end

      it 'returns a Result struct object' do
        expect(optimizator.run).to be_an_instance_of(
          StructuraidCore::Optimization::RebarWithConstantLength::Result
        )
      end

      it 'returns a value at :rebar key' do
        expect(optimizator.run.rebar).not_to be(nil)
      end

      it 'returns a value at :amount_of_rebars key' do
        expect(optimizator.run.amount_of_rebars).not_to be(nil)
      end
    end

    describe '#log' do
      before { optimizator.run }

      it 'returns an Array object' do
        expect(optimizator.log).to be_an_instance_of(Array)
      end
    end
  end
end
