require 'factory_bot'

FactoryBot.define do
  factory :rebar, class: 'StructuraidCore::Elements::Reinforcement::Rebar' do
    material { build(:steel) }
    number { rand(2..8) }

    skip_create
    initialize_with { new(**attributes) }
  end
end
