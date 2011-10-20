# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/lib/servertools')

Gem::Specification.new do |gem|

  ##
  # General configuration / information
  gem.name        = 'servertools'
  gem.version     = ServerTools::Version.current
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = 'Manuel Alabor'
  gem.email       = 'manuel@alabor.me'
  gem.homepage    = 'http://www.github.com/swissmanu/servertools'
  gem.summary     = ''

  ##
  # Files and folder that need to be compiled in to the Ruby Gem
  gem.files         = %x[git ls-files].split("\n")
  #gem.test_files    = %x[git ls-files -- {spec}/*].split("\n")
  gem.require_path  = 'lib'

  ##
  # servertools CLI executable
  gem.executables   = ['servertools']

  ##
  # Gem dependencies
  gem.add_dependency 'thor',   ['~> 0.14.6']

end
