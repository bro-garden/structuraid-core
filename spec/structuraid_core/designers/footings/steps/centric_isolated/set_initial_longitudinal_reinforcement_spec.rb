require 'spec_helper'
require 'byebug'

RSpec.describe StructuraidCore::Designers::Footings::Steps::CentricIsolated::SetInitialLongitudinalReinforcement do
  describe '.call' do
    subject(:result_with_mocked_required_reinforcement_ratio) do
      described_class.call(
        {
          footing:,
          design_code: StructuraidCore::DesignCodes::Nsr10,
          steel: build(:steel),
          support_type: :over_soil,
          analysis_direction: :length_1,
          analysis_results:
        }
      )
    end

    let(:analysis_results) { { computed_ratio: 0.0018, is_minimum_ratio: true } }

    let(:footing) do
      build(
        :footing,
        length_1: 1500,
        length_2: 1500,
        height: 500,
        material: build(:concrete, design_compression_strength: 21)
      )
    end

    let(:coordinates_system) { build(:coordinates_system) }

    before do
      footing.add_coordinates_system(coordinates_system)
      footing.add_vertices_location

      # This stepe requieres that the footing local coordinates system has the following locations (obtainable from the previous steps in our design flow):
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
    end

    it 'is a success' do
      expect(result_with_mocked_required_reinforcement_ratio).to be_a_success
    end

    it 'modifies footing by adding reinforcement layer' do
      expect { result_with_mocked_required_reinforcement_ratio }.to change {
        footing.reinforcement(direction: :length_1, above_middle: false).nil?
      }.from(true).to(false)
    end

    it 'adds reinforcement layer with the correct area' do
      result_with_mocked_required_reinforcement_ratio
      expect(
        footing.reinforcement_ratio(direction: :length_1, above_middle: false) >= analysis_results[:computed_ratio]
      ).to be(true)
    end

    describe 'when rebar ratio is greater than minimum' do
      let(:analysis_results) { { computed_ratio: 0.0030, is_minimum_ratio: false } }

      it 'is a success' do
        expect(result_with_mocked_required_reinforcement_ratio).to be_a_success
      end

      it 'modifies footing by adding reinforcement layer' do
        expect { result_with_mocked_required_reinforcement_ratio }.to change {
          footing.reinforcement(direction: :length_1, above_middle: false).nil?
        }.from(true).to(false)
      end

      it 'adds reinforcement layer with the correct area' do
        result_with_mocked_required_reinforcement_ratio
        expect(
          footing.reinforcement_ratio(direction: :length_1, above_middle: false) >= analysis_results[:computed_ratio]
        ).to be(true)
      end
    end

    describe "when rebar ratio is too higth and can't be solved" do
      let(:analysis_results) { { computed_ratio: 0.9000, is_minimum_ratio: false } }

      it 'is a failure' do
        expect(result_with_mocked_required_reinforcement_ratio).to be_a_failure
      end

      it 'raises a message' do
        expect(
          result_with_mocked_required_reinforcement_ratio.message
        ).to match(
          'be found'
        )
      end

      it "doesn't modify footing by adding reinforcement" do
        result_with_mocked_required_reinforcement_ratio
        expect(footing.reinforcement(direction: :length_1, above_middle: false).nil?).to be(true)
      end
    end
  end
end
