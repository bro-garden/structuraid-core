require 'factory_bot'

FactoryBot.define do
  factory :concrete, class: 'StructuraidCore::Materials::Concrete' do
    elastic_module { 24_870.06 } # N/mm2
    design_compression_strength { 28 } # N/mm2
    specific_weight { 0.000024 } # N/mm3

    skip_create
    initialize_with { new(**attributes) }
  end
end
