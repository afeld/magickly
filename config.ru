require 'rubygems'
require 'bundler'
env = ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :development
Bundler.require(:default, env)

require File.join(File.dirname(__FILE__), 'lib', 'magickly')
run Magickly::App
