module Magickly
  class App < Sinatra::Base
    RESERVED_PARAMS = ['src']
    DEMO_IMAGE = 'http://farm4.static.flickr.com/3351/3450592233_c29fde01ef_z.jpg'
    
    enable :logging
    set :root, File.join(File.dirname(__FILE__), '..')
    set :homepage, "http://github.com/afeld/magickly"
    
    configure :production do
      require 'newrelic_rpm' if ENV['NEW_RELIC_ID']
    end
    
    before do
      # redirect to MAGICKLY_APP_DOMAIN, if specified
      app_host = ENV['MAGICKLY_APP_DOMAIN']
      if app_host && request.host != app_host
        request_host_with_port = request.env['HTTP_HOST']
        redirect request.url.sub(request_host_with_port, app_host), 301
      end
      
      Magickly.dragonfly.datastore.configure do |d|
        # pass cookies to subsequent request
        d.cookie_str = request.env["rack.request.cookie_string"]
      end
      
      # parse query params so they are ordered
      @options = ActiveSupport::OrderedHash.new
      request.query_string.split('&').each do |e|
        k,v = e.split('=')
        @options[k] = URI.unescape(v) unless RESERVED_PARAMS.include?(k)
      end
    end
    
    get '/' do
      src = params['src']
      
      if src
        # process image
        url = uri_to_url(src)
        image = Magickly.process_src(url, @options)
        image.to_response(env)
      else
        # display demo page
        
        # get combined list of jobs and processor methods
        @methods = ( Magickly.dragonfly.job_methods | Magickly.dragonfly.processor_methods )
        @methods.sort!{|m1, m2| m1.to_s <=> m2.to_s }
        erb :index
      end
    end
    
    get '/analyze' do
      @analyzers = Magickly.dragonfly.analyser_methods
      @analyzers.sort!{|m1, m2| m1.to_s <=> m2.to_s }
      erb :analyzers
    end
    
    get '/analyze/:name' do |method|
      src = params[:src]
      if src
        url = uri_to_url(src)
        image = Magickly.process_src(url, @options)
        
        begin
          output = image.send(method.to_sym)
        rescue NoMethodError
          method = method.to_s + '?'
          output = image.send(method.to_sym)
        end
        
        output.is_a?(String) ? output : output.to_json
      else
        status 400
        "Please provide an image URL with the src parameter."
      end
    end
    
    
    def uri_to_url(uri)
      url = Addressable::URI.parse(uri)
      url.site ||= Addressable::URI.parse(request.url).site
      url.to_s
    end
    
    # start the server if ruby file executed directly
    run! if __FILE__ == $0
  end
end

# <b>DEPRECATED:</b> Please use <tt>Magickly::App</tt> instead.
class MagicklyApp < Magickly::App
  def self.run
    warn "This has been deprecated - please use Magickly::App.run"
    super
  end
end
