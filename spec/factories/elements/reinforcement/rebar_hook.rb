require 'factory_bot'

FactoryBot.define do
  factory :rebar_hook, class: 'StructuraidCore::Elements::Reinforcement::RebarHook' do
    material { build(:steel) }
    number { (2..8).to_a.sample }

    skip_create
    initialize_with { new(**attributes) }
  end
end
