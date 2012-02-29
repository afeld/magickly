require 'active_support/json'
require 'active_support/core_ext/object/blank'
require 'active_support/ordered_hash'

require 'sinatra/base'
require 'addressable/uri'
require 'dragonfly'
Dir["#{File.dirname(__FILE__)}/dragonfly/**/*.rb"].each {|file| require file }
Dir["#{File.dirname(__FILE__)}/magickly/**/*.rb"].each {|file| require file }


module Magickly
  DEFAULT_PALETTE_COLOR_COUNT = 5
  
  @dragonfly = Dragonfly[:magickly].configure_with(:imagemagick)
  @dragonfly.configure do |c|
    c.datastore = Dragonfly::DataStorage::RemoteDataStore.new
    c.log = Logger.new($stdout)
    
    # seems this config param was removed from Dragonfly ~v0.9.8
    # c.log_commands = true
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

      skipped_options = {}

      convert = options.inject(nil) do |prev, (k, v)|
        factory = Magickly.get_convert_factory k.to_sym
        if factory.nil?
          skipped_options[k] = v
          prev
        else
          factory.new_convert(image, v, prev)
        end
      end

      image = convert.nil? ? image : convert.execute

      # Handle any remaining options not handled by single convert
      skipped_options.each do |method, val|
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
