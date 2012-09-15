# -*- encoding: utf-8 -*-
require File.expand_path('../lib/materielize/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ray Parker"]
  gem.email         = ["RayParkerBassPlayer@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"

  gem.add_dependency "thor"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "materielize"
  gem.require_paths = ["lib"]
  gem.version       = Materielize::VERSION
end
