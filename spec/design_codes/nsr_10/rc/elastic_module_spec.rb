require 'spec_helper'
require 'design_codes/nsr_10/rc/elastic_module'

# rubocop:disable RSpec/FilePath
RSpec.describe DesignCodes::NSR10::RC::ElasticModule do
  describe '.call' do
    subject(:result) { described_class.call(ultimate_strength: 1) }

    it 'holi' do
      result
    end
  end
end
# rubocop:enable RSpec/FilePath
