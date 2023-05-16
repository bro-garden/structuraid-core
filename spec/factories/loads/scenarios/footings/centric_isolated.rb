require 'factory_bot'

FactoryBot.define do
  factory :loads_scenarios_centric_isolated, class: 'StructuraidCore::Loads::Scenarios::Footings::CentricIsolated' do
    ultimate_load { build(:point_load) }
    service_load { build(:point_load) }

    skip_create
    initialize_with { new(**attributes) }
  end
end
