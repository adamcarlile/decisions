# frozen_string_literal: true

require_relative "lib/decisions/version"

Gem::Specification.new do |spec|
  spec.name = "decisions"
  spec.version = Decisions::VERSION
  spec.authors = ["Adam Carlile"]
  spec.email = ["hello@adamcarlile.com"]

  spec.summary = "A Gem for handling decision making documents in markdown"
  spec.homepage = "https://github.com/adamcarlile/decisions"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/adamcarlile/decisions"
  spec.metadata["changelog_uri"] = "https://github.com/adamcarlile/decisions/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "tty-prompt"
  spec.add_dependency "tty-table"
  
  spec.add_development_dependency "pry"
  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
