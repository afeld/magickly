require 'sinatra/base'
require 'dragonfly'
require File.expand_path(File.join(File.dirname(__FILE__), 'dragonfly', 'data_storage', 'remote_data_store'))


class MagicklyApp < Sinatra::Base
  enable :logging
  
  dragonfly = Dragonfly[:images].configure_with(:imagemagick)
  dragonfly.configure do |c|
    c.datastore = Dragonfly::DataStorage::RemoteDataStore.new
    c.log = Logger.new($stdout)
  end
  set :dragonfly, dragonfly
  
  def magickify(params)
    src = params.delete('src')
    escaped_src = URI.escape(src)
    image = settings.dragonfly.fetch(escaped_src)
    
    # TODO handle non-ordered hash
    params.each do |method, val|
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
      d.cookie_str = request.env["rack.request.cookie_string"]
    end
  end
  
  get '/' do
    image = magickify(params)
    image.to_response(env)
  end
  
  # start the server if ruby file executed directly
  run! if __FILE__ == $0
end
