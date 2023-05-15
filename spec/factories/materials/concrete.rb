require 'factory_bot'

FactoryBot.define do
  factory :concrete, class: 'StructuraidCore::Materials::Concrete' do
    elastic_module { 24_870.06 } # MPa
    design_compression_strength { 28 } # MPa
    specific_weight { 0.000024 } # N/mm3

    skip_create
    initialize_with { new(**attributes) }
  end
end
