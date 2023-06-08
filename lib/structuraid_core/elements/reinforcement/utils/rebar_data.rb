module StructuraidCore
  module Elements
    module Reinforcement
      module Utils
        module RebarData
          def find_standard_diameter(rebar_number:)
            standard_rebar_data = Db::Finder.find_standard_rebar(number: rebar_number)
            standard_rebar_data['diameter'].to_f
          end

          def find_standard_mass(rebar_number:)
            standard_rebar_data = Db::Finder.find_standard_rebar(number: rebar_number)
            standard_rebar_data['linear_mass'].to_f
          end
        end
      end
    end
  end
end
