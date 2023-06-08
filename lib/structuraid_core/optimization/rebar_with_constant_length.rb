module StructuraidCore
  module Optimization
    # Runs optimization of the reinforcement, it asumes that the rebar length is constant, so if any shosen rebar has the same length as any other, the target is just to minimize the total mass by changing the amount of rebars
    class RebarWithConstantLength

      OPTIONAL_REBAR_NUMBERS = [3, 4, 5, 6, 7].freeze
      MINIMUM_REBAR_AMOUNT = 2
      UNSUCCESSFUL_RESULT_CODE = :maximum_spacing_unsatisfied
      SUCCESSFUL_RESULT_CODE = :success

      Result = Struct.new(:rebar, :amount_of_rebars, :result_code)

      # @param required_reinforcement_area [Float] The reinforcement area required by the design
      # @param maximum_rebar_spacing [Float] The maximum spacing between rebars
      # @param coverage_length [Float] The space to cover with the reinforcement, the rebars will be placed with a spacing which must be less than maximum_rebar_spacing
      def initialize(required_reinforcement_area, maximum_rebar_spacing, coverage_length)
        @required_reinforcement_area = required_reinforcement_area
        @maximum_rebar_spacing = maximum_rebar_spacing
        @coverage_length = coverage_length
      end

      def run
        @steps_log = []
        run_optimization
        return unsuccessful_result if current_rebar.nil?

        successful_result
      end

      def log
        steps_log
      end

      private

      attr_reader :required_reinforcement_area,
                  :maximum_rebar_spacing,
                  :coverage_length,
                  :material,
                  :current_mass,
                  :current_rebar,
                  :amount_of_rebars,
                  :steps_log,
                  :iteration_rebar,
                  :iteration_rebars_amount,
                  :iteration_rebar_mass

      def run_optimization
        @material = StructuraidCore::Materials::Steel.new(yield_stress: 420)
        @current_mass = Float::INFINITY
        @current_rebar = nil
        @amount_of_rebars = nil

        find_optimal_rebar
      end

      def find_optimal_rebar
        OPTIONAL_REBAR_NUMBERS.each do |number|
          iteration_rebars_and_amount(number)
          break if iteration_rebars_amount < MINIMUM_REBAR_AMOUNT

          rebar_spacing = coverage_length / (iteration_rebars_amount - 1)
          break if rebar_spacing > maximum_rebar_spacing

          @iteration_rebar_mass = reinforcement_mass(iteration_rebar, iteration_rebars_amount)
          next unless iteration_rebar_mass < current_mass

          commit_results
        end
      end

      def iteration_rebars_and_amount(number)
        @iteration_rebar = StructuraidCore::Elements::Reinforcement::Rebar.new(number:, material:)
        @iteration_rebars_amount = required_amaunt_of_rebar(iteration_rebar)
      end

      def commit_results
        @current_mass = iteration_rebar_mass
        @current_rebar = iteration_rebar
        @amount_of_rebars = iteration_rebars_amount
        @steps_log << "rebar #{@current_rebar.number}: #{iteration_rebars_amount} ----> #{iteration_rebar_mass}"
        puts "rebar #{@current_rebar.number}: #{iteration_rebars_amount} ----> #{iteration_rebar_mass}"
      end

      def required_amaunt_of_rebar(rebar)
        calculated = required_reinforcement_area / rebar.area
        round_amount(calculated.round)
      end

      def amount_of_rebars_based_on_spacing(coverage_length, spacing)
        calculated = coverage_length / spacing
        round_amount(calculated.round)
      end

      def round_amount(calculated_amount)
        integer_amount = calculated_amount.round
        return integer_amount + 1 if integer_amount < calculated_amount

        integer_amount
      end

      def reinforcement_mass(rebar, amount_of_rebars)
        rebar.mass * amount_of_rebars
      end

      def successful_result
        result = Result.new
        result.rebar = current_rebar
        result.amount_of_rebars = amount_of_rebars
        result.result_code = SUCCESSFUL_RESULT_CODE

        result
      end

      def unsuccessful_result
        result = Result.new
        result.rebar = StructuraidCore::Elements::Reinforcement::Rebar.new(
          number: OPTIONAL_REBAR_NUMBERS.first,
          material:
        )
        result.amount_of_rebars = amount_of_rebars_based_on_spacing(coverage_length, maximum_rebar_spacing)
        result.result_code = UNSUCCESSFUL_RESULT_CODE

        result
      end
    end
  end
end
