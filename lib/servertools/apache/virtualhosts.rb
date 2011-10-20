#!/usr/bin/env ruby
require "thor"
require "pathname"
require "yaml"
require "fileutils"

module ServerTools
  module Apache
    
    class VirtualHost < Thor

      ##
      # Creates a new configuration file inside the sites-available directory.
      # The new virtual host gets enabled imediatly if wished.
    	desc "add VHOSTURL", "Adds a new virtual host to the current Apache installation and enables it"
      method_option :admin_mail, :type => :string, :required => true, :aliases => "-m", :desc => "Give the email address of the admin"
    	method_option :server_aliases, :type => :array, :aliases => "-a",  :desc => "Add aliases to your virtual host if you like"
    	method_option :enable, :type => :boolean, :aliases => "-e", :default => true, :desc => "Enable virtual host after creation."
    	def add(virtualhost)
    	  
        #puts "Add new VirtualHost\t#{virtualhost_name}"

        #servertools_path = Pathname.new($0).realpath().parent()
        #document_root = config["apache"]["documentroots"] + "/#{virtualhost_name}"
        #available_site = config["apache"]["available_sites"] + "/#{virtualhost_name}"
        #htdocs_path = "#{document_root}/htdocs"
        #logs_path = "#{document_root}/logs"

        #if File.directory?(document_root)
          #puts "It seems that the VirtualHost \"#{virtualhost_name}\" already exists. Exiting."
          #exit
        #end
    
        # Add document root with its subfolders:
        #create_directory(htdocs_path)
        #create_directory(logs_path)

        # Create virtual host configuration
        #placeholders_with_values = {
        #  "document_root" => document_root,
        #  "htdocs_path" => htdocs_path,
        #  "logs_path" => logs_path,
        #  "virtualhost_name" => virtualhost_name,
        #  "available_site" => available_site,
        #  "server_alias" => server_aliases,
        #  "server_admin" => server_admin
        #}
        #customize_file("#{servertools_path}/templates/virtualhost", available_site, placeholders_with_values)
        #enable_virtualhost(virtualhost_name, config)
    	end
	
    	##
    	# Enables a virtual host by creating a symlink from its configuration file
    	# inside sites-available to sites-enabled.
    	desc "enable VHOSTURL", "Enable an already defined virtual host. It gets accessible over the web."
    	def enable(virtualhost)
        #puts "Enable VirtualHost\t#{virtualhost_name}"
        #available_site = config["apache"]["available_sites"] + "/#{virtualhost_name}"
        #enabled_site = config["apache"]["enabled_sites"] + "/#{virtualhost_name}"

        #if !File.exists?(available_site)
        #  puts "The virtual host #{virtualhost_name} seems not to exist. Use --add to create"
        #  exit
        #end

        #if File.symlink?(enabled_site)
        #  puts "The virtual host #{virtualhost_name} is already enabled."
        #  exit
        #end

        #create_symlink(available_site, enabled_site)
        #reload_apache
      end
  
      ##
      # Disables a virtual host by deleting its symlink inside the sites-enabled
      # directory.
      desc "disable VHOSTURL", "Disables a virtual host. It cannot be accessed then over the web."
      def disable(virtualhost)
    	  Apache.reload_configuration
    	  
        #puts "Disable VirtualHost\t#{virtualhost_name}"
        #enabled_site = config["apache"]["enabled_sites"] + "/#{virtualhost_name}"

        #if !File.symlink?(enabled_site)
        #  puts "The virtual host #{virtualhost_name} is not enabled."
        #  exit
        #end

        #delete_file(enabled_site)
        #reload_apache
      end
	
    end

  end
end

ServerTools::Apache::VirtualHost.start


class VirtualHost_Utility
  
  def initialize
    @config = get_configuration
  end
  
  #
  # Loads the config.yaml and returns the contents as hash
  #
  def get_configuration()
    servertools_path = Pathname.new($0).realpath().parent()
    YAML.load_file("#{servertools_path}/config.yml")
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
    puts "Delete file/\t#{file}"
    FileUtils.remove(file)
  end

  #
  # Creates a symlink from source to target and puts a message to the console.
  #
  def create_symlink(source, target)
    puts "Create symlink\t\t#{source} -> #{target}"
    FileUtils.symlink(source, target)
  end
  
end