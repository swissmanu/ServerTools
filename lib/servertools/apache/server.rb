module ServerTools
  module Apache

    class Server
      ##
      # Forces Apache to reload its configuration
      def self.reload_configuration!
        ServerTools::Logger.message("Reload Apache configuration")
        `/etc/init.d/apache2 reload`
      end
      
      ##
      # Restarts Apache
      def self.restart!
        ServerTools::Logger.message("Restart Apache")
        `/etc/init.d/apache2 restart`
      end
    end
    
  end
end