module Varnish
  
  module EsiExpire
    def self.included(base)
      base.class_eval do
        # the max-age esi parameter is ignored by varnish
        # buts it does care about the max-age of the http header
        # so we pass it to the esi request
        append_after_filter{|controller| controller.response.headers["Cache-Control"] = "max-age=#{controller.params[:ttl]},public,must-revalidate" if controller.request.format == :esi}
      end
    end
  end
  
  # this module comes from fragment_fu
  # http://mongrel-esi.googlecode.com/svn/trunk/plugin/fragment_fu/
  module RenderWithEsi
    def self.included(base)
      base.class_eval do
        alias_method_chain :render, :esi_option
      end
    end

    def render_with_esi_option(options = {}, old_local_assigns = {}, &block)
      if options[:esi]
        render_esi(options)
      else
        render_without_esi_option(options, old_local_assigns, &block)
      end
    end

    def render_esi(options)
      url = options[:esi]
      query = (url.is_a?(Hash) ? controller.url_for(url.merge({:only_path => true})) : url.gsub(/\.\w+?$/,''))
      # the max-age esi parameter is ignored by varnish
      # buts it does care about the max-age of the http header
      # so we pass it to the esi request
      %Q{<esi:include src="#{query}.esi?ttl=#{options[:ttl].to_i || 0}" max-age="#{options[:ttl].to_i || 0}"/>} 
    end
  end
end