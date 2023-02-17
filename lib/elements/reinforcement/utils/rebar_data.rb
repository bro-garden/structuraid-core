require 'db/base'

module Elements
  module Reinforcement
    module Utils
      module RebarData
        def find_standard_diameter(rebar_number:)
          standard_rebar_data = DB::Base.find_standard_rebar(number: rebar_number)
          standard_rebar_data['diameter'].to_f
        end
      end
    end
  end
end
