require 'sinatra/base'
require 'dragonfly'
require File.expand_path(File.join(File.dirname(__FILE__), 'dragonfly', 'data_storage', 'remote_data_store'))


class MagicklyApp < Sinatra::Base
  enable :logging
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
    
    # TODO handle non-ordered hash
    options.each do |method, val|
      if val == 'true'
        image = image.process method
      else
        image = image.process method, val
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
    src = params.delete('src')
    
    if src
      image = magickify(src, params)
      image.to_response(env)
    else
      redirect settings.homepage
    end
  end
  
  # start the server if ruby file executed directly
  run! if __FILE__ == $0
end
