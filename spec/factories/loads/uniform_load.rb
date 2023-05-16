require 'factory_bot'

FactoryBot.define do
  factory :uniform_load, class: 'StructuraidCore::Loads::UniformLoad' do
    start_value { rand(0..100) }
    end_value { rand(0..100) }
    start_location { build(:absolute_location) }
    end_location { build(:absolute_location) }

    skip_create
    initialize_with { new(**attributes) }
  end
end
