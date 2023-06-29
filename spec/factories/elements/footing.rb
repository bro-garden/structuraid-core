require 'factory_bot'

FactoryBot.define do
  factory :footing, class: 'StructuraidCore::Elements::Footing' do
    length_1 { rand(1000..5000) }
    length_2 { rand(1000..5000) }
    height { rand(300..700) }
    material { build(:concrete) }
    cover_lateral { 50 }
    cover_top { 50 }
    cover_bottom { 75 }

    trait :with_reinforcement do
      longitudinal_top_reinforcement_length_1 do
        build(:straight_longitudinal_reinforcement, distribution_direction: :length_2, above_middle: true)
      end
      longitudinal_bottom_reinforcement_length_1 do
        build(:straight_longitudinal_reinforcement, distribution_direction: :length_2, above_middle: false)
      end
      longitudinal_top_reinforcement_length_2 do
        build(:straight_longitudinal_reinforcement, distribution_direction: :length_1, above_middle: true)
      end
      longitudinal_bottom_reinforcement_length_2 do
        build(:straight_longitudinal_reinforcement, distribution_direction: :length_1, above_middle: false)
      end
    end

    skip_create
    initialize_with { new(**attributes) }
  end
end
