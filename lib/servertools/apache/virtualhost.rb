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

        put_option(:document_root,  join_and_expand_path(document_roots, @name, "htdocs"))
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
      
      ##
      # If not already existing, this method creates a symlink for this virtual
      # host inside of Apaches sites-enabled directory.
      def enable!
        available_site = join_and_expand_path(ServerTools::Configuration.get("apache","available_sites"), @name)
        enabled_site   = join_and_expand_path(ServerTools::Configuration.get("apache","enabled_sites"), @name)

        if File.symlink?(enabled_site)
          ServerTools::Logger.error("#{@name } is already enabled")
          exit
        end
        if !File.exists?(available_site)
          ServerTools::Logger.error("#{@name} does not exist!")
          exit
        end

        FileUtils.symlink(available_site, enabled_site)
        ServerTools::Logger.message("#{@name} enabled")
      end
      
      ##
      # If existing, deletes the symlink for this virtual host in Apaches
      # sites-enabled directory.
      def disable!
        enabled_site = join_and_expand_path(ServerTools::Configuration.get("apache","enabled_sites"), @name)
        
        if !File.symlink?(enabled_site)
          ServerTools::Logger.error("#{@name} is not enabled!")
          exit
        end
        
        File.delete(enabled_site)
        ServerTools::Logger.message("#{@name} disabled")
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
      
      ##
      # Takes parts of a path, joins them and expand it to an absolute path.
      def join_and_expand_path(*parts)
        File.expand_path(File.join(parts))
      end
      
    end
  end
end
