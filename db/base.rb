require 'yaml'

module DB
  module Base
    STANDARD_REBAR = YAML.load_file('db/rebars.yml')
  end
end
