require 'spec_helper'
require 'engineering/analysis/footing/centric_combined'
require 'elements/reinforcement/straight_longitudinal'
require 'materials/concrete'
require 'materials/steel'
require 'elements/reinforcement/rebar'
require 'loads/point_load'
require 'engineering/locations/relative'
require 'engineering/locations/absolute'
require 'errors/engineering/analysis/section_direction_error'
require 'elements/column/rectangular'
require 'elements/footing'
require 'byebug'

RSpec.describe Engineering::Analysis::Footing::CentricCombined do
  subject(:centric_isolated_footing) do
    described_class.new(footing:, loads_from_columns:, section_direction:)
  end

  let(:load_from_column) { Loads::PointLoad.new(value: 1500, location: nil) }
  let(:section_direction) { :length_1 }
  let(:footing) do
    Elements::Footing.new(
      length_1:,
      length_2:,
      height:,
      material: Materials::Concrete.new(
        elastic_module: 1800,
        design_compression_strength: 28,
        specific_weight: 2.4
      ),
      cover_lateral:,
      cover_top:,
      cover_bottom:,
      longitudinal_bottom_reinforcement_length_1: nil,
      longitudinal_bottom_reinforcement_length_2: nil
    )
  end
  let(:length_1) { 8000 }
  let(:length_2) { 3000 }
  let(:height) { 250 }
  let(:cover_lateral) { 50 }
  let(:cover_top) { 50 }
  let(:cover_bottom) { 75 }
  let(:loads_from_columns) do
    [
      Loads::PointLoad.new(
        value: 1000,
        location: Engineering::Locations::Absolute.new(
          value_x: 2500,
          value_y: 2500,
          value_z: 0
        )
      ),
      Loads::PointLoad.new(
        value: 4000,
        location: Engineering::Locations::Absolute.new(
          value_x: 5500,
          value_y: 6500,
          value_z: 0
        )
      )
    ]
  end

end
