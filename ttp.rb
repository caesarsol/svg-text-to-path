#!/usr/bin/env ruby
$LOAD_PATH << "#{File.expand_path('lib', File.dirname(__FILE__))}"

require 'svg_file'

svg_input   = ARGV[0]
svg_output  = ARGV[1]

DEBUG = ARGV.include? '--debug'

puts "DEBUG Mode" if DEBUG

svg = SVGFile.new(svg_input)
svg.textToPath(debug: DEBUG)
svg.save(svg_output)
puts "Generated #{svg_output}"

