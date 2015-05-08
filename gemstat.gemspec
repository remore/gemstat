Gem::Specification.new do |s|
  s.name = 'gemstat'
  s.version = '0.1.0'
  s.homepage = 'https://github.com/remore/gemstat'

  s.authors = 'Kei Sawada(@remore)'
  s.email   = 'k@swd.cc'

  s.files = `git ls-files`.split("\n")
  s.bindir = 'bin'
  s.executables = 'gemstat'

  s.summary = 'A gem usage analyzer'
  s.description = 'gemstat is a gem usage analyzer which tells you the number of gems used and even similarlity of each gems'
  s.license = 'MIT'
end
