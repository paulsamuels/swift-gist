
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "swift/gist/version"

Gem::Specification.new do |spec|
  spec.name          = "swift-gist"
  spec.version       = Swift::Gist::VERSION
  spec.authors       = ["Paul Samuels"]
  spec.email         = ["paulio1987@gmail.com"]

  spec.summary       = %q{A tool for watching a subset of Swift files and executing tests.}
  spec.description   = %q{A tool for watching a subset of Swift files and executing tests.}
  spec.homepage      = "https://github.com/paulsamuels/swift-gist"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>=2.3.3'

  spec.add_runtime_dependency 'listen', '~> 3.1.5'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "simplecov", "~> 0.16.1"
end
