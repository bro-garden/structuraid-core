require 'spec_helper'
require 'byebug'

RSpec.describe(
  StructuraidCore::Designers::Footings::Steps::CentricIsolated::CheckReinforcement
) do
  describe '.call' do
    subject(:result_with_mocked_required_reinforcement_ratio) { described_class.call(params) }

    let(:params) do
      {
        footing:,
        analysis_direction: :length_1,
        design_code: StructuraidCore::DesignCodes::Resolver.use('nsr_10'),
        steel: build(:steel),
        support_type: :over_soil,
        analysis_results:
      }
    end

    let(:coordinates_system) { build(:coordinates_system) }
    let(:reinforcement) do
      build(
        :straight_longitudinal_reinforcement,
        distribution_direction: :length_2,
        above_middle: false
      )
    end

    let(:footing) do
      build(
        :footing,
        length_1: 1500,
        length_2: 1500,
        height: 500,
        material: build(:concrete, design_compression_strength: 21)
      )
    end

    before do
      footing.add_coordinates_system(coordinates_system)
      footing.add_vertices_location
      footing.coordinates_system.find_or_add_location_from_vector(
        footing.coordinates_system.find_location(:vertex_bottom_left).to_vector + Vector[
          footing.cover_lateral, footing.cover_lateral, footing.cover_bottom
        ],
        label: 'reinforcement_layer_start_location_length_1_bottom'
      )

      footing.coordinates_system.find_or_add_location_from_vector(
        footing.coordinates_system.find_location(:vertex_top_right).to_vector + Vector[
          -footing.cover_lateral, -footing.cover_lateral, footing.cover_bottom
        ],
        label: 'reinforcement_layer_end_location_length_1_bottom'
      )

      footing.add_longitudinal_reinforcement(reinforcement, :length_1, above_middle: false)

      reinforcement.add_layer(
        start_location: footing.coordinates_system.find_location('reinforcement_layer_start_location_length_1_bottom'),
        end_location: footing.coordinates_system.find_location('reinforcement_layer_end_location_length_1_bottom'),
        amount_of_rebars:,
        rebar:
      )
    end

    describe 'when footing has reinforcement' do
      describe 'when reinforcement spacing is greater than maximum' do
        let(:amount_of_rebars) { 2 }
        let(:rebar) { build(:rebar, number: 3) }
        let(:analysis_results) { { computed_ratio: 0.0500, is_minimum_ratio: false } }

        it 'is a failure' do
          expect(result_with_mocked_required_reinforcement_ratio).to be_a_failure
        end
      end

      describe 'when reinforcement spacing is less or equal than maximum' do
        let(:amount_of_rebars) { 13 }
        let(:rebar) { build(:rebar, number: 5) }
        let(:analysis_results) { { computed_ratio: 0.0030, is_minimum_ratio: false } }

        it 'is a success' do
          expect(result_with_mocked_required_reinforcement_ratio).to be_a_success
        end
      end
    end
  end
end
