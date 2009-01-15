require 'test_helper'

context 'plugin installation' do
  specify 'it should write the configuration file' do
    File.expects(:open).with("./config/varnish.yml",'w')
    require 'install.rb'
  end
end

context 'purge varnish' do
  specify 'it should alias expire_page and expire_action' do
    ActionController::Base.expects(:alias_method_chain).with(:expire_action, :varnish)
    ActionController::Base.expects(:alias_method_chain).with(:expire_page, :varnish)
    load 'lib/varnish.rb'
  end
  
  specify 'it should raise when config file is malformed' do
    ac = ActionController::Base.new
    YAML.expects(:load_file).returns({})
    assert_raise VarnishBadConfiguration do
      ac.expire_page('/bla')
    end
  end
  
  specify 'it should open a socket to varnish to PURGE /bla on the current host' do
    ac = ActionController::Base.new
    ac.request.expects(:host).returns('test_host')
    YAML.expects(:load_file).returns({:varnish => {:ip => '127.0.0.1', :port => 80}})
    ts = TCPSocket.new('127.0.0.1',80)
    TCPSocket.expects(:new).with('127.0.0.1',80).returns(ts)
    ts.expects(:write).with("PURGE /bla HTTP/1.1\r\nUser-Agent: ruby/socket\r\nAccept: */*\r\nHost: test_host\r\n\r\n")
    ac.expire_page('/bla')
  end
end


context 'edge side includes' do
  specify 'it should alias render to render_with_esi_option' do
    ActionView::Base.expects(:alias_method_chain).with(:render, :esi_option)
    load 'lib/varnish.rb'
  end
    
  specify 'it should create an esi include anchor' do
    av = ActionView::Base.new
    av.render(:esi => '/bla').should.equal "<esi:include src=\"/bla.esi?ttl=0\" max-age=\"0\"/>"
  end
end