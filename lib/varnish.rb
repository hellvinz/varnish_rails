require 'varnish/expire_cache'
require 'varnish/esi'

Mime::Type.register_alias 'text/html', :esi 

ActionController::Base.send(:include, Varnish::CacheAction)
ActionController::Base.send(:include, Varnish::CachePage)
ActionController::Base.send(:include, Varnish::EsiExpire)
ActionView::Base.send(:include, Varnish::RenderWithEsi)