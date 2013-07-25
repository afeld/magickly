# -*- encoding: utf-8 -*-
require 'rake'

Gem::Specification.new do |s|
  s.name = 'magickly'
  s.version = '1.4.0'

  s.authors = ['Aidan Feldman']
  s.date = '2013-02-27'
  s.description = "A service for image manipulation - built as an extensible wrapper of Imagemagick which handles caching, c/o the Dragonfly gem."
  s.email = 'aidan.feldman@gmail.com'
  s.extra_rdoc_files = %w(
    LICENSE.txt
    README.md
  )
  s.files = FileList['lib/**/*.rb', 'bin/*', '[A-Z]*', 'spec/**/*'].to_a
  s.homepage = 'http://magickly.afeld.me'
  s.licenses = ['MIT']
  s.require_paths = ['lib']
  s.summary = "image manipulation as a (plugin-able) service"

  s.add_dependency('sinatra', ['~> 1.2'])
  s.add_dependency('dragonfly', ['~> 0.9.14'])
  s.add_dependency('addressable', ['~> 2.2'])
  s.add_dependency('httparty', ['~> 0.8'])
  s.add_dependency('activesupport', ['>= 2.0.0'])
end
