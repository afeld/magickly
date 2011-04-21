require 'active_support/core_ext/object/blank'
require 'active_support/ordered_hash'

require 'sinatra/base'
require 'dragonfly'
require File.expand_path(File.join(File.dirname(__FILE__), 'dragonfly', 'data_storage', 'remote_data_store'))
Dir["#{File.dirname(__FILE__)}/magickly/*.rb"].each {|file| require file }


class MagicklyApp < Magickly::App
  def self.run
    warn "This has been deprecated - please use Magickly::App.run"
    super
  end
  
  # start the server if ruby file executed directly
  run! if __FILE__ == $0
end
