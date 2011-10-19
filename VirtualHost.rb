require 'optparse'
require 'yaml'
require 'fileutils'

#
# Parse command line arguments and return them inside a hash.
#
def parse_arguments()
  arguments = {}

  optparse = OptionParser.new do |opts|
    opts.banner = "Use: VirtualHost.rb --add --name VHOSTNAME --serveradmin ADMINEMAIL"
  
    opts.on('--add', 'Adds a new VirtualHost to Apache') do
      arguments[:action] = :add
    end
    
    opts.on('--name NAME', String, 'Name for the VirtualHost') do |name|
      arguments[:name] = name
    end
    
    opts.on('--aliases alias1,alias2,...', Array, 'If needed, pass aliases for your server') do |aliases|
      arguments[:server_aliases] = "ServerAlias\t#{aliases.join(' ')}"
    end
    
    opts.on('--serveradmin ADMINEMAIL', String, 'E-Mail address of the server admin') do |serveradmin|
      arguments[:server_admin] = serveradmin
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
    raise OptionParser::MissingArgument if arguments[:server_admin].nil?
    arguments[:server_aliases] = "" if arguments[:server_aliases].nil?
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
# Picks a file and replaces contained placeholders with the values from the
# hash placeholders_with_values.
# The resulting content gets then written to target.
#
def customize_file(source, target, placeholders_with_values)
  puts "Customize file\t\t#{source} -> #{target}"
  
  content = File.read(source)
  
  placeholders_with_values.keys.each do |placeholder|
    content = content.gsub(/\{#{placeholder}\}/, placeholders_with_values[placeholder])
  end
  
  puts content
  
end

#
# Creates a symlink from source to target and puts a message to the console.
#
def create_symlink(source, target)
  puts "Create symlink\t\t#{source} -> #{target}"
  FileUtils.symlink(source, target)
end

#
# Adds a VirtualHost to Apache
# Actions:
#  * Add config in available_sites
#  * Add symlink in enabled_sites
#  * Add virtual host to virtual host configuration
#
def add_virtualhost(virtualhost_name, server_admin, server_aliases, config)
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
  
  # Create virtual host configuration
  placeholders_with_values = {
    "document_root" => document_root,
    "htdocs_path" => htdocs_path,
    "logs_path" => logs_path,
    "virtualhost_name" => virtualhost_name,
    "available_site" => available_site,
    "server_alias" => server_aliases,
    "server_admin" => server_admin
  }
  customize_file("templates/virtualhost", available_site, placeholders_with_values)
  create_symlink(available_site, enabled_site)
  
end


#
# Run the actual script ;-)
#
puts "VirtualHost Management"
puts "======================"

arguments = parse_arguments
config = get_configuration

add_virtualhost(arguments[:name], arguments[:server_admin], arguments[:server_aliases], config) if arguments[:action] == :add