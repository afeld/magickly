$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'magickly'
require 'rack/test'
require 'sinatra'
require 'webmock/rspec'
require 'fastimage'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
# Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

set :environment, :test

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
end

def compare_binary(one, two)
  # Ruby 1.9
  unless one.encoding == two.encoding
    one = one.force_encoding("UTF-8")
    two = two.force_encoding("UTF-8")
  end

  expect(one).to eq two
end
