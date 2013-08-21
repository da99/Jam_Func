
Gem::Specification.new do |s|
  s.name        = 'Jam_Func'
  s.version     = %x(cat VERSION)
  s.date        = '2013-08-21'
  s.summary     = "Not ready."
  s.description = "Run a group of functions with flow control."
  s.authors     = ["da99"]
  s.email       = 'da99@da99'
  #s.executables = ["Jam_Func"]
  s.files       = `ls lib/`.split("
").map { |f| "lib/#{f}" }
  s.homepage    = 'http://www.github.com/da99/Jam_Func'
  s.license     = 'MIT'

  s.require_paths = ["lib"]
  #s.add_runtime_dependency 'erector'
  s.add_development_dependency('bacon')
  s.add_development_dependency('Bacon_Colored')
end

