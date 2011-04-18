require 'active_support/core_ext/object/blank'
require 'active_support/ordered_hash'

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
  
  def magickify(src, options={})
    raise ArgumentError.new("src needed") if src.blank?
    escaped_src = URI.escape(src)
    image = settings.dragonfly.fetch(escaped_src)
    
    stash = ActiveSupport::OrderedHash.new
    options.each do |method, val|
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
      options = ActiveSupport::OrderedHash.new
      request.query_string.split('&').each do |e|
        k,v = e.split('=')
        options[k] = v if k != 'src'
      end
      image = magickify(src, options)
      image.to_response(env)
    else
      # fallback for Dragonfly v0.8.2 and below
      klass = Dragonfly::ImageMagick::Processor rescue Dragonfly::Processing::ImageMagickProcessor
      @methods = klass.instance_methods(false)
      haml :index
    end
  end
  
  # start the server if ruby file executed directly
  run! if __FILE__ == $0
end

