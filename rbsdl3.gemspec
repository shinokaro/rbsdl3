# frozen_string_literal: true
require_relative "lib/rb_sdl3/version"

Gem::Specification.new do |spec|
  spec.name = "rbsdl3"
  spec.version = RbSDL3::VERSION
  spec.authors = ["shinokaro"]
  spec.email = ["shinokaro@hotmail.co.jp"]

  spec.summary = "RbSDL3 is an SDL3 binding for Ruby implemented using Fiddle."
  spec.description = <<~EOT
    RbSDL3 is a Ruby binding to SDL3 that links against an SDL dynamic library chosen at runtime.
    Types, constants, structures, and macros are available on the Ruby side before the library is loaded,
    and most bindings are automatically generated from SDL’s header files via c2ffi’s AST output,
    with only a subset of APIs and macros implemented by hand.
  EOT
  spec.homepage = "https://github.com/shinokaro/rbsdl3"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/shinokaro/rbsdl3"
  spec.metadata["changelog_uri"] = "https://github.com/shinokaro/rbsdl3/CHANGELOG.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile
        Rakefile rakelib/ manifest/ template/])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.1.0"
  spec.add_dependency "fiddle", "~> 1.1.8"
end
