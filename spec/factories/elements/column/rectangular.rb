require 'factory_bot'

FactoryBot.define do
  factory :rectangular_column, class: 'StructuraidCore::Elements::Column::Rectangular' do
    length_1 { 500 }
    length_2 { 500 }
    height { 3000 }
    material { build(:concrete) }
    label { 'column' }

    skip_create
    initialize_with { new(**attributes) }
  end
end
