$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'magickly'
require 'rack/test'
require 'sinatra'
require 'webmock/rspec'
require 'image_size'
#require 'ruby-debug'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

set :environment, :test

RSpec.configure do |config|
  
end

class StubFilter < Magickly::Filter
  def self.call(options={})
    "all good"
  end
end
