# -*- encoding: utf-8 -*-
require File.expand_path('../lib/materielize/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ray Parker"]
  gem.email         = ["RayParkerBassPlayer@gmail.com"]
  gem.description   = %q{A helper for default config files.}
  gem.summary       = %q{Helps with the stowage and installation of default config files -- helpful for dev and CI environments.}
  gem.homepage      = "http://github.com/RayParkerBassPlayer/materielize"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"

  gem.add_dependency "thor"
  gem.add_dependency "highline"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "materielize"
  gem.require_paths = ["lib"]
  gem.version       = Materielize::VERSION
end
