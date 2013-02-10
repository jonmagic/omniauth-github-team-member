# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-github-team-member/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Jonathan Hoyt']
  gem.email         = ['jonmagic@gmail.com']
  gem.description   = %q{OmniAuth strategy for GitHub Team Auth.}
  gem.summary       = %q{OmniAuth strategy for GitHub Team Auth.}
  gem.homepage      = 'https://github.com/jonmagic/omniauth-github-team-member'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = 'omniauth-github-team-member'
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::GitHubTeamMember::VERSION

  gem.add_dependency 'omniauth-github'
  gem.add_development_dependency 'rspec', '~> 2.7'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'webmock'
end
