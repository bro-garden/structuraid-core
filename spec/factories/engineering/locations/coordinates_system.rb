require 'factory_bot'

FactoryBot.define do
  factory :coordinates_system, class: 'StructuraidCore::Engineering::Locations::CoordinatesSystem' do
    anchor_location { build(:absolute_location) }

    trait :ucs do
      anchor_location { build(:absolute_location, :origin) }
    end

    skip_create
    initialize_with { new(**attributes) }
  end
end
