require 'sinatra/base'
require 'dragonfly/rails/images'

require File.join(File.dirname(__FILE__), 'dragonfly', 'data_storage', 'remote_data_store')


class ImageryApp < Sinatra::Base
  app = Dragonfly[:images]
  app.datastore = Dragonfly::DataStorage::RemoteDataStore.new
  
  before do
    app.datastore.configure do |d|
      d.cookie_str = request.env["rack.request.cookie_string"]
    end
  end
  
  get '/' do
    image = app.fetch(params[:src])
    
    # only scale down
    width = (params[:width] && image.width < params[:width].to_i) ? nil : params[:width]
    height = (params[:height] && image.height < params[:height].to_i) ? nil : params[:height]
    image = image.process :resize, "#{width}x#{height}" if width or height
    
    image.to_response(env)
  end
  
  # start the server if ruby file executed directly
  run! if app_file == $0
end
