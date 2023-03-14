# frozen_string_literal: true

RSpec.describe StructuraidCore do
  it 'has a version number' do
    expect(StructuraidCore::VERSION).not_to be nil
  end

  # rubocop:disable RSpec/ExpectActual
  it 'does something useful' do
    expect(true).to eq(true)
  end
  # rubocop:enable RSpec/ExpectActual
end
