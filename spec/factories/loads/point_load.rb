require 'factory_bot'

FactoryBot.define do
  factory :point_load, class: 'StructuraidCore::Loads::PointLoad' do
    value { rand(0..100) }
    location { build(:absolute_location) }
    label { "point_load_#{rand(0..1_000)}" }

    skip_create
    initialize_with { new(**attributes) }
  end
end
