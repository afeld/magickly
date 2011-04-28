require 'active_support/core_ext/object/blank'
require 'active_support/ordered_hash'

require 'sinatra/base'
require 'addressable/uri'
require 'dragonfly'
require File.expand_path(File.join(File.dirname(__FILE__), 'dragonfly', 'data_storage', 'remote_data_store'))
Dir["#{File.dirname(__FILE__)}/magickly/*.rb"].each {|file| require file }


module Magickly
  @dragonfly = Dragonfly[:images].configure_with(:imagemagick)
  @dragonfly.configure do |c|
    c.datastore = Dragonfly::DataStorage::RemoteDataStore.new
    c.log = Logger.new($stdout)
  end
  
  DRAGONFLY_PROCESSOR_FUNCTIONS = @dragonfly.processor.functions.keys
  
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
        if !DRAGONFLY_PROCESSOR_FUNCTIONS.include?(method.to_sym)
          # might be an app-defined dragonfly shortcut
          image = image.send(method, val)
        elsif val == 'true'
          image = image.process method
        else
          image = image.process method, val
        end
      end
      
      image
    end
  end
end

require File.expand_path(File.join(File.dirname(__FILE__), 'shortcuts'))

# start the server if ruby file executed directly
Magickly::App.run! if __FILE__ == $0
