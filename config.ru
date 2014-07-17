require 'rubygems'
require 'bundler'
require 'dotenv'

Bundler.require

Dotenv.load

require File.join(File.dirname(__FILE__), 'lib', 'magickly')

use Rack::Cache,
  :verbose     => true,
  :metastore   => 'file:tmp/cache/rack/meta',
  :entitystore => 'file:tmp/cache/rack/body'

run Magickly::App
