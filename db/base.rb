require 'yaml'

module DB
  STANDARD_REBAR = YAML.load_file('db/rebars.yml')
end
