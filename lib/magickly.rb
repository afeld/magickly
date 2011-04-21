require 'active_support/core_ext/object/blank'
require 'active_support/ordered_hash'

require 'sinatra/base'
require 'dragonfly'
require File.expand_path(File.join(File.dirname(__FILE__), 'dragonfly', 'data_storage', 'remote_data_store'))
Dir["#{File.dirname(__FILE__)}/magickly/*.rb"].each {|file| require file }


module Magickly
  @filters = []
  
  @dragonfly = Dragonfly[:images].configure_with(:imagemagick)
  @dragonfly.configure do |c|
    c.datastore = Dragonfly::DataStorage::RemoteDataStore.new
    c.log = Logger.new($stdout)
  end
  
  class << self
    def filters
      @filters
    end
    
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
  
  # start the server if ruby file executed directly
  App.run! if __FILE__ == $0
end
