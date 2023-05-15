require 'factory_bot'

FactoryBot.define do
  factory :straight_longitudinal_reinforcement, class: 'StructuraidCore::Elements::Reinforcement::StraightLongitudinal' do
    distribution_direction { %i[length_1 length_2].sample }
    above_middle { [true, false].sample }

    skip_create
    initialize_with { new(**attributes) }
  end
end
