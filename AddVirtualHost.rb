require 'optparse'
require 'yaml'
require 'fileutils'

#
# Parse passed arguments and save them as hash in arguments:
#
def parse_arguments()
  arguments = {}

  optparse = OptionParser.new do |opts|
    opts.banner = "Use: AddVirtualHost.rb --name [virtual host name] --dns [dns name]"
  
    opts.on('--name NAME', String, 'Name for the VirtualHost') do |name|
      arguments[:name] = name
    end
  
    opts.on('--dns DNS', String, 'DNS name which should be mapped to this VirtualHost') do |dns|
      arguments[:dns] = dns
    end
  
    opts.on('-h', '--help', 'Display this screen') do
      puts opts
      exit
    end
  end

  optparse.parse!
  raise OptionParser::MissingArgument if arguments[:name].nil?
  raise OptionParser::MissingArgument if arguments[:dns].nil?

  arguments
end


parse_arguments