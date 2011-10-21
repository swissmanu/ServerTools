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
  autoload :Configuration,  File.join(LIBRARY_PATH, "configuration")
  autoload :Logger,         File.join(LIBRARY_PATH, "logger")
  autoload :Version,        File.join(LIBRARY_PATH, "version")
  
  ##
  # Apache tools
  module Apache
    autoload :Server,       File.join(APACHE_PATH, "server")
    autoload :VirtualHost,  File.join(APACHE_PATH, "virtualhost")
  end
  
end