require 'optparse'
require 'yaml'
require 'fileutils'

#
# Parse command line arguments and return them inside a hash.
#
def parse_arguments()
  arguments = {}

  optparse = OptionParser.new do |opts|
    opts.banner = "Use: VirtualHost.rb --add --name VHOSTNAME"
  
    opts.on('--add', 'Adds a new VirtualHost to Apache') do
      arguments[:action] = :add
    end
    
    opts.on('--name NAME', String, 'Name for the VirtualHost') do |name|
      arguments[:name] = name
    end
  
    opts.on('-h', '--help', 'Display this screen') do
      puts opts
      exit
    end
  end

  optparse.parse!
  
  # Validate:
  raise OptionParser::MissingArgument if arguments[:action].nil?
  if arguments[:action] == :add
    raise OptionParser::MissingArgument if arguments[:name].nil?
  end

  arguments
end

#
# Loads the config.yaml and returns the contents as hash
#
def get_configuration()
  YAML.load_file("config.yml")
end

#
# Creates the complete path passed and puts a message to the console.
#
def create_directory(path)
  puts "Create directory\t#{path}"
  FileUtils.mkpath(path)
end

#
# Adds a VirtualHost to Apache
# Actions:
#  * Add config in available_sites
#  * Add symlink in enabled_sites
#  * Add virtual host to virtual host configuration
#
def add_virtualhost(virtualhost_name, config)
  puts "Add new VirtualHost\t#{virtualhost_name}"
  
  document_root = config["apache"]["documentroots"] + "/#{virtualhost_name}"
  available_site = config["apache"]["available_sites"] + "/#{virtualhost_name}"
  enabled_site = config["apache"]["enabled_sites"] + "/#{virtualhost_name}"
  htdocs_path = "#{document_root}/htdocs"
  logs_path = "#{document_root}/logs"
  
  if File.directory?(document_root)
    puts "It seems that the VirtualHost \"#{virtualhost_name}\" already exists. Exiting."
    exit
  end
  
  # Add document root with its subfolders:
  create_directory(htdocs_path)
  create_directory(logs_path)
end


#
# Run the actual script ;-)
#
puts "VirtualHost Management"
puts "======================"

arguments = parse_arguments
config = get_configuration

add_virtualhost(arguments[:name], config) if arguments[:action] == :add