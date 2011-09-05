source 'http://rubygems.org'

gem 'sinatra', '~> 1.2.1', :require => 'sinatra/base'
gem 'dragonfly', '~> 0.9.1'
gem 'addressable', '~> 2.2', :require => 'addressable/uri'

gem 'httparty', '~> 0.7.3'
gem 'activesupport', '>= 2.0.0', :require => false

group :development do
  gem 'jeweler', '~> 1.5'
  gem 'rcov', '>= 0'
end

group :development, :test do
  gem 'rack-test'
  gem 'rspec', '~> 2.4'
  gem 'webmock', '~> 1.6'
  gem 'imagesize', '~> 0.1'
end

group :production do
  gem 'newrelic_rpm', :require => false
end
