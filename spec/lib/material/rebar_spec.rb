require 'spec_helper'
require 'material/rebar'

RSpec.describe Material::Rebar do
  let(:e_module) { 200_000 }
  let(:diameter) { 6.4 }

  describe '#f_y' do
    describe 'when f_limit is less than MAX_FY' do
      let(:rebar) { described_class.new(f_limit:, e_module:, diameter:) }
      let(:f_limit) { described_class::MAX_FY - 100 }

      it 'returns MAX_FY' do
        expect(rebar.f_y).to eq(f_limit)
      end
    end

    describe 'when f_limit is greater than MAX_FY' do
      let(:rebar) { described_class.new(f_limit:, e_module:, diameter:) }
      let(:f_limit) { described_class::MAX_FY + 100 }

      it 'returns MAX_FY' do
        expect(rebar.f_y).to eq(described_class::MAX_FY)
      end
    end
  end

  describe '#area' do
    describe 'when diameter is 6.4' do
      let(:rebar) { described_class.new(f_limit:, e_module:, diameter:) }
      let(:f_limit) { described_class::MAX_FY - 100 }

      it 'returns the correct area' do
        area_for_used_diameter = Math::PI * (diameter**2) / 4
        expect(rebar.area).to be(area_for_used_diameter)
      end
    end
  end
end
