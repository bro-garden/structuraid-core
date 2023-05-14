# frozen_string_literal: true

require_relative 'lib/structuraid_core/version'

Gem::Specification.new do |spec|
  spec.name = 'structuraid_core'
  spec.version = StructuraidCore::VERSION
  spec.authors = ['Pradaing']
  spec.email = ['engineering@pradic.co']

  spec.summary = 'Gem with core utilities and functionality to design building structures'

  description = <<-DESCRIPTION
    structuraid_core is a gem that offers a set of functionalities to assist in the design building structures.
  DESCRIPTION
  spec.description = description.strip

  spec.homepage = 'https://github.com/PradaIng/structuraid-core'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.2'

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/PradaIng/structuraid-core/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'byebug', '~> 11.1.3'
  spec.add_development_dependency 'guard-rspec', '~> 4.7.3'
  spec.add_development_dependency 'puma'
  spec.add_development_dependency 'rack'
  spec.add_development_dependency 'rspec', '~> 3.11.0'
  spec.add_development_dependency 'rubocop', '~> 1.41.1'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.16.0'
  spec.add_development_dependency 'simplecov', '~> 0.22.0'
  spec.add_development_dependency 'yard'

  spec.add_dependency 'interactor', '~> 3.0'
  spec.add_dependency 'matrix', '~> 0.4.2'
  spec.add_dependency 'rake', '~> 13.0.6'
  spec.add_dependency 'require_all', '~> 3.0.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
