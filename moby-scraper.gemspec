#coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name                     =   "moby-scraper"
  spec.version                  =   "0.1"
  spec.authors                  =   ["Alexander Young"]
  spec.email                    =   ["alexander@lxndryng.com"]
  spec.summary                  =   %q{A scraper for MobyGames with Elasticsearch saving of data}
  spec.description              =   %q{A scraper for MobyGames with Elasticsearch saving of data}
  spec.homepage                 =   "http://lxndryng.com"
  spec.license                  =   "GPL"

  spec.files                    =   ['lib/moby-scraper.rb']
  spec.executables              =   ['bin/moby-scraper']
  spec.test_files               =   ['tests/test_moby-scraper.rb']
  spec.require_paths            =   ['lib']
  spec.add_runtime_dependency 'nokogiri', [">=1.6.0"]
  spec.add_runtime_dependency 'elasticsearch', [">=0"]
  spec.add_development_dependency 'simplecov', [">=0"]
end
