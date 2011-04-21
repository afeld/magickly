module Magickly
  @dragonfly = Dragonfly[:images].configure_with(:imagemagick)
  @dragonfly.configure do |c|
    c.datastore = Dragonfly::DataStorage::RemoteDataStore.new
    c.log = Logger.new($stdout)
  end
  
  class << self
    def dragonfly
      @dragonfly
    end
    
    def process_src(src, options={})
      raise ArgumentError.new("src needed") if src.blank?
      escaped_src = URI.escape(src)
      image = Magickly.dragonfly.fetch(escaped_src)
      
      process_image(image, options)
    end
    
    def process_image(image, options={})
      options.each do |method, val|
        if val == 'true'
          image = image.process method
        else
          image = image.process method, val
        end
      end
      
      image
    end
  end
  
  class App < Sinatra::Base
    RESERVED_PARAMS = ['src']
    
    enable :logging
    set :root, File.join(File.dirname(__FILE__), '..')
    set :homepage, "http://github.com/afeld/magickly"
    
    before do
      Magickly.dragonfly.datastore.configure do |d|
        # pass cookies to subsequent request
        d.cookie_str = request.env["rack.request.cookie_string"]
      end
      
      @options = ActiveSupport::OrderedHash.new
      request.query_string.split('&').each do |e|
        k,v = e.split('=')
        @options[k] = v unless RESERVED_PARAMS.include?(k)
      end
    end
    
    get '/' do
      src = params['src']
      
      if src
        image = Magickly.process_src(src, @options)
        image.to_response(env)
      else
        # display demo page
        
        # fallback for Dragonfly v0.8.2 and below
        klass = Dragonfly::ImageMagick::Processor rescue Dragonfly::Processing::ImageMagickProcessor
        @methods = klass.instance_methods(false)
        haml :index
      end
    end
    
    get '/filters' do
      Magickly.filters.inspect
    end
    
    get '/filters/*' do
      klass = params[:splat].first.classify.constantize rescue nil
      
      if klass
        klass.call(params)
      else
        status 404
        "filter does not exist"
      end
    end
    
    # start the server if ruby file executed directly
    run! if __FILE__ == $0
  end
end
