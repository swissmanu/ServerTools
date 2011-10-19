#!/usr/bin/env ruby

require "optparse"
require "yaml"
require "fileutils"

#
# Parse command line arguments and return them inside a hash.
#
def parse_arguments()
  arguments = {}

  optparse = OptionParser.new do |opts|
    opts.banner = "Add:\t--add NAME --serveradmin ADMINMAIL [--aliases ALIAS1,ALIAS2,...]\nRemove:\t--remove NAME"
  
    opts.on("--add NAME", String, "Adds a new VirtualHost to Apache") do |name|
      arguments[:action] = :add
      arguments[:name] = name
    end
    
    opts.on("--remove NAME", String, "Removes a Virtual Host (if existing)") do |name|
      arguments[:action] = :remove
      arguments[:name] = name
    end
    
    opts.on("--enable NAME", String, "Enables a Virtual Host") do |name|
      arguments[:action] = :enable
      arguments[:name] = name
    end
    
    opts.on("--disable NAME", String, "Disable a Virtual Host") do |name|
      arguments[:action] = :disable
      arguments[:name] = name
    end
    
    opts.on("--serveradmin ADMINMAIL", String, "E-Mail address of the server admin") do |serveradmin|
      arguments[:server_admin] = serveradmin
    end
    
    opts.on("--aliases ALIAS1,ALIAS2,...", Array, "If needed, pass aliases for your server") do |aliases|
      arguments[:server_aliases] = "ServerAlias\t#{aliases.join(' ')}"
    end
  
    opts.on("-h", "--help", "Display this screen") do
      puts opts
      exit
    end
  end

  optparse.parse!
  
  # Validate:
  raise OptionParser::MissingArgument if arguments[:action].nil?
  if arguments[:action] == :add
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
  
  File.open(target, "w") do |f| f.puts content end
end

#
# Deletes a file and puts a message to the console.
#
def delete_file(file)
  puts "Delete file\t#{file}"
  FileUtils.remove(file)
end

#
# Creates a symlink from source to target and puts a message to the console.
#
def create_symlink(source, target)
  puts "Create symlink\t\t#{source} -> #{target}"
  FileUtils.symlink(source, target)
end

#
# Forces Apache to reload its configuration
#
def reload_apache
  puts "Reload Apache"
  `/etc/init.d/apache2 reload`
end

#
# Adds a VirtualHost to Apache
# Actions:
#  * Add config in available_sites
#  * Add symlink in enabled_sites
#
def add_virtualhost(virtualhost_name, server_admin, server_aliases, config)
  puts "Add new VirtualHost\t#{virtualhost_name}"
  
  document_root = config["apache"]["documentroots"] + "/#{virtualhost_name}"
  available_site = config["apache"]["available_sites"] + "/#{virtualhost_name}"
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
  enable_virtualhost(virtualhost_name, config)
end

#
# Deletes a Virtual host if possible.
#
def remove_virtualhost(virtualhost_name, config)
  puts "Remove VirtualHost\t#{virtualhost_name}"
  puts " -> not yet implemented, sry ;)"
  
  document_root = config["apache"]["documentroots"] + "/#{virtualhost_name}"
end

#
# Creates a symlink from the sites-available directory to the sites-enabled
# directory for the given virtual host.
#
def enable_virtualhost(virtualhost_name, config)
  puts "Enable VirtualHost\t#{virtualhost_name}"
  available_site = config["apache"]["available_sites"] + "/#{virtualhost_name}"
  enabled_site = config["apache"]["enabled_sites"] + "/#{virtualhost_name}"
  
  if !File.exists?(available_site)
    puts "The virtual host #{virtualhost_name} seems not to exist. Use --add to create"
    exit
  end
  
  if File.symlink?(enabled_site)
    puts "The virtual host #{virtualhost_name} is already enabled."
    exit
  end
  
  create_symlink(available_site, enabled_site)
  reload_apache
end

#
# Deletes the symlink of a virtualhost in the sites-enabled directory.
#
def disable_virtualhost(virtualhost_name, config)
  puts "Disable VirtualHost\t#{virtualhost_name}"
  enabled_site = config["apache"]["enabled_sites"] + "/#{virtualhost_name}"
  
  if !File.symlink?(enabled_site)
    puts "The virtual host #{virtualhost_name} is not enabled."
    exit
  end
  
  delete_file(enabled_site)
  reload_apache
end

#
# Run the actual script ;-)
#
puts "VirtualHost Management"
puts "======================"

arguments = parse_arguments
config = get_configuration

add_virtualhost(arguments[:name], arguments[:server_admin], arguments[:server_aliases], config) if arguments[:action] == :add
remove_virtualhost(arguments[:name], config) if arguments[:action] == :remove
enable_virtualhost(arguments[:name], config) if arguments[:action] == :enable
disable_virtualhost(arguments[:name], config) if arguments[:action] == :disable