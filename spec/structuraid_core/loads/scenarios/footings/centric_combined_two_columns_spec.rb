require 'spec_helper'

RSpec.describe StructuraidCore::Loads::Scenarios::Footings::CentricCombinedTwoColumns do
  subject(:scenario) { described_class.new(ultimate_loads:, service_loads:) }

  let(:ultimate_loads) do
    [
      StructuraidCore::Loads::PointLoad.new(
        value: -40_000,
        location: StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 1000,
          value_y: 4000,
          value_z: 0
        ),
        label: 'column_1'
      ),
      StructuraidCore::Loads::PointLoad.new(
        value: -10_000,
        location: StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 1000,
          value_y: -1000,
          value_z: 0
        ),
        label: 'column_2'
      )
    ]
  end

  let(:service_loads) do
    [
      StructuraidCore::Loads::PointLoad.new(
        value: -30_000,
        location: StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 1000,
          value_y: 4000,
          value_z: 0
        ),
        label: 'column_1'
      ),
      StructuraidCore::Loads::PointLoad.new(
        value: -8_000,
        location: StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 1000,
          value_y: -1000,
          value_z: 0
        ),
        label: 'column_2'
      )
    ]
  end

  xit 'does something :P'
end
