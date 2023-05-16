require 'factory_bot'

FactoryBot.define do
  factory :absolute_location, class: 'StructuraidCore::Engineering::Locations::Absolute' do
    value_x { rand(0..100) }
    value_y { rand(0..100) }
    value_z { rand(0..100) }

    trait :origin do
      value_x { 0 }
      value_y { 0 }
      value_z { 0 }
    end

    skip_create
    initialize_with { new(**attributes) }
  end
end
