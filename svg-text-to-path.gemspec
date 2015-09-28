# coding: utf-8
lib = File.join(File.dirname(__FILE__), 'lib')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = 'svg-text-to-path'
  s.version     = '0.0.1'
  s.license     = 'GPL-3.0'
  s.authors     = ["Cesare Soldini"]
  s.email       = ['cesare.soldini@gmail.com']
  s.date        = '2015-09-22'
  s.summary     = "Ruby script that scans SVG files and transforms <text> tags in paths, given an existing SVG font."
  #s.description = %q{}
  s.homepage    = ''

  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.require_paths = ["lib"]
  s.bindir        = "bin"
  s.executables   = ["svg-ttp"]

  s.add_dependency 'nokogiri', '~> 1'

  s.add_development_dependency 'bundler', '~> 1'
  s.add_development_dependency 'rake',    '~> 10'
  s.add_development_dependency 'rspec',   '~> 3'
end
