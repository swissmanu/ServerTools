require 'fileutils'
require 'yaml'

module ServerTools
  
  ##
  # Internal paths
  LIBRARY_PATH  = File.join(File.dirname(__FILE__), "servertools")
  APACHE_PATH   = File.join(LIBRARY_PATH, "apache")
  
  ##
  # Common ServerTools stuff
  autoload :Base,           File.join(LIBRARY_PATH, "base")
  autoload :Logger,         File.join(LIBRARY_PATH, "logger")
  autoload :Version,        File.join(LIBRARY_PATH, "version")
  
  ##
  # Apache tools
  module Apache
    autoload :Base,         File.join(APACHE_PATH, "base")
    autoload :VirtualHost,  File.join(APACHE_PATH, "virtualhost")
  end
  
end