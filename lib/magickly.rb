require 'sinatra/base'
require 'dragonfly'
require File.expand_path(File.join(File.dirname(__FILE__), 'dragonfly', 'data_storage', 'remote_data_store'))


class MagicklyApp < Sinatra::Base
  enable :logging
  set :root, File.dirname(__FILE__)
  set :homepage, "http://github.com/afeld/magickly"
  
  dragonfly = Dragonfly[:images].configure_with(:imagemagick)
  dragonfly.configure do |c|
    c.datastore = Dragonfly::DataStorage::RemoteDataStore.new
    c.log = Logger.new($stdout)
  end
  set :dragonfly, dragonfly
  
  def magickify(src, options)
    escaped_src = URI.escape(src)
    image = settings.dragonfly.fetch(escaped_src)
    
    options = options.entries if options.is_a? Hash
    stash = {}
    options.each do |pair|
      method, val = pair
      if method == 'filter'
        stash[method.to_sym] = val
      else
        if val == 'true'
          image = image.process method, stash
        else
          image = image.process method, val, stash
        end
        stash = {}
      end
    end
    
    image
  end
  
  before do
    dragonfly.datastore.configure do |d|
      # pass cookies to subsequent request
      d.cookie_str = request.env["rack.request.cookie_string"]
    end
  end
  
  get '/' do
    src = params['src']
    
    if src
      options = request.query_string.split('&').map do |e|
        k,v = e.split('=')
        [k,v] if k != 'src'
      end
      options.compact!
      image = magickify(src, options)
      image.to_response(env)
    else
      @methods = Dragonfly::ImageMagick::Processor.instance_methods(false)
      haml :index
    end
  end
  
  # start the server if ruby file executed directly
  run! if __FILE__ == $0
end
