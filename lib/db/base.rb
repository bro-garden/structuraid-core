require 'yaml'

module DB
  module Base
    STANDARD_REBAR = YAML.load_file('lib/db/rebars.yml')
  end
end
