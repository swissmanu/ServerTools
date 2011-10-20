module ServerTools
  module Apache

    ##
    # Forces Apache to reload its configuration
    #
    def reload_configuration
      puts "Reload Apache"
      `/etc/init.d/apache2 reload`
    end
    
  end
end