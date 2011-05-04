module Magickly
  class App < Sinatra::Base
    RESERVED_PARAMS = ['src']
    
    enable :logging
    set :root, File.join(File.dirname(__FILE__), '..')
    set :homepage, "http://github.com/afeld/magickly"
    
    configure :production do
      require 'newrelic_rpm' if ENV['NEW_RELIC_ID']
    end
    
    
    before do
      Magickly.dragonfly.datastore.configure do |d|
        # pass cookies to subsequent request
        d.cookie_str = request.env["rack.request.cookie_string"]
      end
      
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
        
        uri = Addressable::URI.parse(src)
        uri.site ||= Addressable::URI.parse(request.url).site
        
        image = Magickly.process_src(uri.to_s, @options)
        image.to_response(env)
      else
        # display demo page
        
        # fallback for Dragonfly v0.8.2 and below
        klass = Dragonfly::ImageMagick::Processor rescue Dragonfly::Processing::ImageMagickProcessor
        @methods = klass.instance_methods(false)
        haml :index
      end
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
