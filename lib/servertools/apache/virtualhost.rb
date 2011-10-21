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
      # If value is an Array, it gets joined by spaces before the value gets
      # added to the options Hash.
      # If value is nil, nothing happens.
      def put_option(key, value)
        if !value.nil?
          value = value.join(" ") if value.kind_of?(Array)
          @options[key] = value
        end
      end

      ##
      # Takes the information of this VirtualHost and creates the configuration
      # files for the Apache installation.
      def create!
        document_roots  = ServerTools::Configuration.get("apache","documentroots")
        logs            = join_and_expand_path(document_roots, @name, "logs")
        available_site  = join_and_expand_path(ServerTools::Configuration.get("apache","available_sites"), @name)        

        put_option(:document_root,  join_and_expand_path(document_roots, @name))
        put_option(:error_log,      join_and_expand_path(logs, "error.log"))
        put_option(:custom_log,     "#{join_and_expand_path(logs,"access.log")} combined")
        
        ServerTools::Logger.message("Create VirtualHost \"#{@name}\"")
        ServerTools::Logger.message("Document root: #{@options[:document_root]}")
        ServerTools::Logger.message("Logs: #{logs}")
        ServerTools::Logger.message("Configuration: #{available_site}")
        
        if File.exists?(available_site)
          ServerTools::Logger.error("Configuration does already exist!")
          exit
        end
        if Dir.exists?(@options[:document_root])
          ServerTools::Logger.error("Document root does already exist!")
          exit
        end
        
        FileUtils.mkpath(@options[:document_root])
        FileUtils.mkpath(logs)
        
        File.open(available_site, "w") do |f|
          f.puts %Q{\#
\# #{@name} (#{available_site})
\#
<VirtualHost *>
#{parse_options(@options)}
</VirtualHost>
          }
        end
        
      end
      
      def delete!
        
      end
      
      def enable!
        
      end
      
      def disable!
        
      end
      
      private
      
      ##
      # Takes a Hash and looks for supported options, translates them into
      # Apache understandable configuration directives and returns the complete
      # stuff as String.
      def parse_options(options)
        parsed_options = ""
        parsed_options << translate_option_key(:admin_email,    "ServerAdmin",    options)
        parsed_options << translate_option_key(:document_root,  "DocumentRoot",   options)
        parsed_options << translate_option_key(:aliases,        "ServerAlias",    options)
        parsed_options << translate_option_key(:directory_index,"DirectoryIndex", options)
        parsed_options << translate_option_key(:error_log,      "ErrorLog",       options)
        parsed_options << translate_option_key(:custom_log,     "CustomLog",      options)
      end
      
      ##
      # Looks for a key inside options. If found, plain_key and the value of
      # the actual key gets returned as String.
      # Returns "" if key is not present in options
      def translate_option_key(key, plain_key, options)
        return "  #{plain_key}\t#{options[key]}\n" if options.has_key?(key)
        ""
      end
      
      def join_and_expand_path(*parts)
        File.expand_path(File.join(parts))
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
