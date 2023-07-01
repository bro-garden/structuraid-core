require 'spec_helper'
require 'byebug'

RSpec.describe(
  StructuraidCore::Designers::Footings::Steps::CentricIsolated::AddOrCheckReinforcement
) do
  describe '.call' do
    subject(:result_with_mocked_required_reinforcement_ratio) { described_class.call(params) }

    let(:params) do
      {
        footing:,
        analysis_direction: :length_1,
        design_code: StructuraidCore::DesignCodes::Nsr10,
        steel: build(:steel),
        support_type: :over_soil,
        analysis_results:
      }
    end

    let(:coordinates_system) { build(:coordinates_system) }

    before do
      footing.add_coordinates_system(coordinates_system)
      footing.add_vertices_location
    end

    describe "when footing doesn't have reinforcement" do
      let(:footing) do
        build(
          :footing,
          length_1: 1500,
          length_2: 1500,
          height: 500,
          material: build(:concrete, design_compression_strength: 21)
        )
      end

      describe 'when computed ratio can be supplied' do
        let(:analysis_results) { { computed_ratio: 0.0050, is_minimum_ratio: false } }

        it 'is a success' do
          expect(result_with_mocked_required_reinforcement_ratio).to be_a_success
        end

        it 'modifies footing by adding reinforcement' do
          expect { result_with_mocked_required_reinforcement_ratio }.to change {
            footing.reinforcement(direction: :length_1, above_middle: false).nil?
          }.from(true).to(false)
        end

        it 'adds reinforcement with the correct ratio' do
          result_with_mocked_required_reinforcement_ratio

          expect(
            footing.reinforcement_ratio(direction: :length_1, above_middle: false) >= analysis_results[:computed_ratio]
          ).to eq(true)
        end

        it 'adds reinforcement layer coordinates for start' do
          result_with_mocked_required_reinforcement_ratio

          expect(
            footing.coordinates_system.find_location('reinforcement_layer_start_location_length_1_bottom')
          ).not_to be_nil
        end

        it 'adds reinforcement layer coordinates for end' do
          result_with_mocked_required_reinforcement_ratio

          expect(
            footing.coordinates_system.find_location('reinforcement_layer_end_location_length_1_bottom')
          ).not_to be_nil
        end
      end

      describe "when computed ratio can't be supplied" do
        let(:analysis_results) { { computed_ratio: 1.000, is_minimum_ratio: false } }

        it 'is a failure' do
          expect(result_with_mocked_required_reinforcement_ratio).to be_a_failure
        end

        it "doesn't modify footing by adding reinforcement" do
          expect { result_with_mocked_required_reinforcement_ratio }.not_to(
            change { footing.reinforcement(direction: :length_1, above_middle: false).nil? }
          )
        end

        it 'adds reinforcement layer coordinates for start' do
          result_with_mocked_required_reinforcement_ratio

          expect(
            footing.coordinates_system.find_location('reinforcement_layer_start_location_length_1_bottom')
          ).not_to be_nil
        end

        it 'adds reinforcement layer coordinates for end' do
          result_with_mocked_required_reinforcement_ratio

          expect(
            footing.coordinates_system.find_location('reinforcement_layer_end_location_length_1_bottom')
          ).not_to be_nil
        end
      end
    end

    describe 'when footing has reinforcement' do
      let(:reinforcement) { build(:straight_longitudinal_reinforcement) }

      before do
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

        footing.add_longitudinal_reinforcement(reinforcement, :length_2, above_middle: false)

        reinforcement.add_layer(
          start_location: footing.coordinates_system.find_location('reinforcement_layer_start_location_length_1_bottom'),
          end_location: footing.coordinates_system.find_location('reinforcement_layer_end_location_length_1_bottom'),
          amount_of_rebars:,
          rebar:
        )
      end

      describe 'reinforcement ratio is below computed ratio' do
        let(:footing) do
          build(
            :footing,
            length_1: 1500,
            length_2: 1500,
            height: 500,
            material: build(:concrete, design_compression_strength: 21)
          )
        end
        let(:amount_of_rebars) { 3 }
        let(:rebar) { build(:rebar, number: 3) }
        let(:analysis_results) { { computed_ratio: 0.0500, is_minimum_ratio: false } }

        it 'is a failure' do
          expect(result_with_mocked_required_reinforcement_ratio).to be_a_failure
        end
      end
    end
  end
end
