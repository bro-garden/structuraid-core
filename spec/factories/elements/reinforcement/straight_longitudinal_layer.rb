require 'factory_bot'

FactoryBot.define do
  factory :straight_longitudinal_layer_reinforcement,
          class: 'StructuraidCore::Elements::Reinforcement::StraightLongitudinalLayer' do
    start_location { build(:relative_location) }
    end_location { build(:relative_location) }
    amount_of_rebars { rand(1..10) }
    rebar { build(:rebar) }
    distribution_direction { %i[length_1 length_2].sample }

    skip_create
    initialize_with { new(**attributes) }
  end
end
