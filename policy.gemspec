require File.expand_path('../lib/policy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_development_dependency 'rspec'
  gem.add_runtime_dependency 'activesupport'

  gem.authors = ['Tom Blomfield']
  gem.description = %q{Simple implementation of Policy Objects in Ruby}
  gem.email = ['tomblomfield@gmail.com']
  gem.files = `git ls-files`.split("\n")
  gem.homepage = 'https://github.com/tomblomfield/policy'
  gem.name = 'policy'
  gem.require_paths = ['lib']
  gem.summary = %q{Simple Policy Objects}
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version = Policy::VERSION.dup
end