require 'active_support/core_ext/object/blank'
require 'active_support/ordered_hash'

require 'sinatra/base'
require 'addressable/uri'
require 'dragonfly'
require File.expand_path(File.join(File.dirname(__FILE__), 'dragonfly', 'data_storage', 'remote_data_store'))
Dir["#{File.dirname(__FILE__)}/magickly/*.rb"].each {|file| require file }


module Magickly
  COLOR_PALETTE_SIZE = 5
  
  @dragonfly = Dragonfly[:images].configure_with(:imagemagick)
  @dragonfly.configure do |c|
    c.datastore = Dragonfly::DataStorage::RemoteDataStore.new
    c.log = Logger.new($stdout)
    c.log_commands = true
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
        method = method.to_sym
        if Magickly.dragonfly.processor_methods.include?(method)
          if val == 'true'
            image = image.process method
          else
            image = image.process method, val
          end
        elsif Magickly.dragonfly.job_methods.include?(method)
          # note: might be an app-defined dragonfly shortcut
          image = image.send(method, val)
        end
      end
      
      image
    end
  end
end

require File.expand_path(File.join(File.dirname(__FILE__), 'shortcuts'))

# start the server if ruby file executed directly
Magickly::App.run! if __FILE__ == $0
