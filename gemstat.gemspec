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

  s.summary = 'A PoC rubygem recommends you a bunch of gems by collaborative filtering approach(something like Amazon\'s "Customers Who Bought This Also Bought")'
  s.description = 'gemstat tells you not only suggested gems unveiled by collaborative filitering but also similar gems, dependencies of a gem and popular gems etc.'
  s.license = 'MIT'

  s.add_dependency "thor"
  s.add_dependency "bundler"
  s.add_development_dependency "rubygems-mirror'"
end
