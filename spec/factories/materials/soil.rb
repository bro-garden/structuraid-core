require 'factory_bot'

FactoryBot.define do
  factory :soil, class: 'StructuraidCore::Materials::Soil' do
    bearing_capacity { 0.53 } # N/mm2

    skip_create
    initialize_with { new(**attributes) }
  end
end
