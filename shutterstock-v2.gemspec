lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)
require 'client/version'

Gem::Specification.new do |s|
  s.name        = 'shutterstock-v2'
  s.version     = Shutterstock::VERSION
  s.summary     = 'A ruby client to work with shutterstock API v2'
  s.description = "see summary"
  s.authors     = ['David Peterson']
  s.email       = 'dp@vivitec.com.au'
  s.files       = `git ls-files`.split($/)
  s.test_files  = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.homepage    = 'https://github.com/dippysan/shutterstock'
  s.add_dependency "rspec"
  s.add_dependency "equalizer"
  s.add_dependency "faraday"
  s.add_dependency "faraday_middleware"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-rescue"
  s.add_development_dependency "pry-stack_explorer"
  s.add_development_dependency "pry-nav"
  s.add_development_dependency "vcr"
  s.add_development_dependency "webmock"
  s.add_development_dependency "rake"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rubocop"
end
