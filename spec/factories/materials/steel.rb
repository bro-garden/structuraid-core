require 'factory_bot'

FactoryBot.define do
  factory :steel, class: 'StructuraidCore::Materials::Steel' do
    yield_stress { 420 } # N/mm2
    elastic_module { StructuraidCore::Materials::Steel::DEFAULT_ELASTIC_MODULE } # MPa

    skip_create
    initialize_with { new(**attributes) }
  end
end
