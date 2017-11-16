
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "search_query_parser/version"

Gem::Specification.new do |spec|
  spec.name          = "search_query_parser"
  spec.version       = SearchQueryParser::VERSION
  spec.authors       = ["Eugene Zolotarev"]
  spec.email         = ["eugzol@gmail.com"]

  spec.summary       = %q{Parser for simple search query language and an interpreter to produce PostgreSQL tsearch directives}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "racc", "~> 1.4"
end
