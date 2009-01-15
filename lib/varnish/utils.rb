require 'socket'
require 'yaml'
require 'uri'

class VarnishBadConfiguration < Exception;;end

class VarnishUtils
  include Singleton
  
  CONFIG_FILE = "#{RAILS_ROOT}/config/varnish.yml"
  
  def initialize
    @configured = false
    config = YAML.load_file(CONFIG_FILE)
    @varnish_ip = config[:varnish][:ip]
    @varnish_port = config[:varnish][:port]
    @configured = true
  rescue => e
    puts "Check your config file: #{CONFIG_FILE}"
    raise VarnishBadConfiguration
  end
  
  def purge(domain, uri)
    return unless configured?
    socket = TCPSocket.new( @varnish_ip, @varnish_port)
    socket.write "PURGE #{uri} HTTP/1.1\r\nUser-Agent: ruby/socket\r\nAccept: */*\r\nHost: #{domain}\r\n\r\n"
    socket.close
  end
  
  private
  def configured?
    @configured ? true : raise(VarnishBadConfiguration,"Check your config file: #{CONFIG_FILE}")
  end

end