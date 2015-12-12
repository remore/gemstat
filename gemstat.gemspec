lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gemstat/version'

Gem::Specification.new do |s|
  s.name = 'gemstat'
  s.version = Gemstat::VERSION
  s.homepage = 'https://github.com/remore/gemstat'

  s.authors = 'Kei Sawada(@remore)'
  s.email   = 'k@swd.cc'

  s.files = `git ls-files`.split("\n")
  s.bindir = 'bin'
  s.executables = 'gemstat'

  s.summary = '"Customers Who Bought(Required) This Item Also Bought(Required)"-ish thing for rubygem '
  s.description = 'gemstat enable you to know "Frequently Bought(Required) Together" thing or "Customers Who Bought(Required) This Item Also Bought(Required)" thing.'
  s.license = 'MIT'

  s.add_dependency "thor"
  s.add_dependency "bundler"
  s.add_development_dependency "rubygems-mirror'"
end
