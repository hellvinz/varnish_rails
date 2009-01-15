require 'yaml'

defaults = {:varnish => {:ip => '127.0.0.1', :port => 80}}

config_dest = "./config/varnish.yml"

File.open(config_dest, 'w') { |f| f.write(YAML.dump(defaults)) }
if File.exists?(config_dest)
  puts "File: #{config_dest} already exists, would you like to overide it? (Y/n)"
  exit if [110,78].include? STDIN.getc 
end

puts "Creating varnish.yml config file to #{config_dest}"
