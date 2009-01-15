require 'varnish/utils'

module Varnish
  module CachePage
    def self.included(base)
      base.send(:alias_method_chain, :expire_page, :varnish)
    end

    def expire_page_with_varnish(path)
      VarnishUtils.instance.purge(request.host,path)
      expire_page_without_varnish(path)
    end
  end
  
  module CacheAction
    def self.included(base)
      base.send(:alias_method_chain, :expire_action, :varnish)
    end

    def expire_action_with_varnish(path)
      VarnishUtils.instance.purge(request.host,path)
      expire_action_without_varnish(path)
    end
  end
end