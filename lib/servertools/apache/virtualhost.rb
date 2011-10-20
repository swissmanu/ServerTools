#!/usr/bin/env ruby
require "pathname"
require "fileutils"

module ServerTools
  module Apache
    
    ##
    # Represents a virtual host with all its properties and possible actions.
    class VirtualHost

      ##
      # Virtual host name. Example: www.host.com
      attr_accessor :name
      
      ##
      # Create a new VirtualHost with name
      def initialize(name)
        @name = name
        @options = Hash.new
      end

      ##
      # Adds an option to this VirtualHost
      def put_option(key, value)
        @options[key] = value
      end

      def create
        
      end
      
      def delete
        
      end
      
      def enable
        
      end
      
      def disable
        
      end
      

      ##
      # Creates a new configuration file inside the sites-available directory.
      # The new virtual host gets enabled imediatly if wished.
    	#def add(virtualhost)
    	  
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
    	#end
	
    	##
    	# Enables a virtual host by creating a symlink from its configuration file
    	# inside sites-available to sites-enabled.
    	#def enable(virtualhost)
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
      #end
  
      ##
      # Disables a virtual host by deleting its symlink inside the sites-enabled
      # directory.
      #def disable(virtualhost)
    	  #Apache.reload_configuration
    	  
        #puts "Disable VirtualHost\t#{virtualhost_name}"
        #enabled_site = config["apache"]["enabled_sites"] + "/#{virtualhost_name}"

        #if !File.symlink?(enabled_site)
        #  puts "The virtual host #{virtualhost_name} is not enabled."
        #  exit
        #end

        #delete_file(enabled_site)
        #reload_apache
      #end
	
    end

  end
end
