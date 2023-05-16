require 'factory_bot'

FactoryBot.define do
  factory :relative_location, class: 'StructuraidCore::Engineering::Locations::Relative' do
    value_1 { rand(0..100) }
    value_2 { rand(0..100) }
    value_3 { rand(0..100) }
    label { "location_#{rand(0..1_000)}" }

    trait :origin do
      value_1 { 0 }
      value_2 { 0 }
      value_3 { 0 }
    end

    skip_create
    initialize_with { new(**attributes) }
  end
end
