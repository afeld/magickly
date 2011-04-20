require 'active_support/core_ext/object/blank'
require 'active_support/ordered_hash'

require 'sinatra/base'
require 'dragonfly'
require File.expand_path(File.join(File.dirname(__FILE__), 'dragonfly', 'data_storage', 'remote_data_store'))
Dir["#{File.dirname(__FILE__)}/magickly/*.rb"].each {|file| require file }


class MagicklyApp < Sinatra::Base
  RESERVED_PARAMS = ['src']
  
  enable :logging
  set :root, File.dirname(__FILE__)
  set :homepage, "http://github.com/afeld/magickly"
  
  dragonfly = Dragonfly[:images].configure_with(:imagemagick)
  dragonfly.configure do |c|
    c.datastore = Dragonfly::DataStorage::RemoteDataStore.new
    c.log = Logger.new($stdout)
  end
  set :dragonfly, dragonfly
  
  def magickify(src, options={})
    raise ArgumentError.new("src needed") if src.blank?
    escaped_src = URI.escape(src)
    image = settings.dragonfly.fetch(escaped_src)
    
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
    
    @options = ActiveSupport::OrderedHash.new
    request.query_string.split('&').each do |e|
      k,v = e.split('=')
      @options[k] = v unless RESERVED_PARAMS.include?(k)
    end
  end
  
  get '/' do
    src = params['src']
    
    if src
      image = magickify(src, @options)
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
  
  # start the server if ruby file executed directly
  run! if __FILE__ == $0
end

