require 'sinatra/base'
require 'dragonfly'
require File.expand_path(File.join(File.dirname(__FILE__), 'dragonfly', 'data_storage', 'remote_data_store'))


class MagicklyApp < Sinatra::Base
  dragonfly = Dragonfly[:images].configure_with(:imagemagick)
  dragonfly.datastore = Dragonfly::DataStorage::RemoteDataStore.new
  set :dragonfly, dragonfly
  
  def magickify(params)
    src = params.delete('src')
    image = settings.dragonfly.fetch(src)
    
    # TODO handle non-ordered hash
    params.each do |method, val|
      image = image.process method, val
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
