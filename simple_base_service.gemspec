# frozen_string_literal: true

require_relative "lib/simple_service/version"

Gem::Specification.new do |spec|
  spec.name = "simple_base_service"
  spec.version = SimpleService::VERSION
  spec.authors = ["ModeraX"]
  spec.email = ["emseh@protonmail.com"]

  spec.summary = "Tiny framework for plain Ruby service objects"
  spec.description = "Provides a `Base` class for service objects with `.run`/`#call`, simple error handling, and configurable logging."
  spec.homepage = "https://github.com/moderax/simple_base_service"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  # spec.metadata["allowed_push_host"] = nil
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/moderax/simple_base_service"
  spec.metadata["changelog_uri"] = "https://github.com/moderax/simple_base_service/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .standard.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
