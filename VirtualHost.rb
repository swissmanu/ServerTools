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


arguments = parse_arguments
config = get_configuration


puts config["apache"]["available_sites"]


#
# 
#
#if !File.directory?('test')
#  FileUtils.mkdir('test')
#end