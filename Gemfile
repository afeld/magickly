source 'http://rubygems.org'

gem 'sinatra', '~> 1.2', :require => 'sinatra/base'
gem 'dragonfly', '~> 0.9.5'
gem 'addressable', '~> 2.2', :require => 'addressable/uri'

gem 'httparty', '~> 0.8.1'
gem 'activesupport', '>= 2.0.0', :require => false

group :development do
  gem 'jeweler', '~> 1.5'
end

group :development, :test do
  if ENV['JUX_DEBUG']
    gem 'linecache19', '0.5.13', :path => "~/.rvm/gems/ruby-1.9.3-p0/gems/linecache19-0.5.13/"
    gem 'ruby-debug-base19', '0.11.26', :path => "~/.rvm/gems/ruby-1.9.3-p0/gems/ruby-debug-base19-0.11.26/"
    gem 'ruby-debug19', :require => 'ruby-debug'
  end
  gem 'rack-test'
  gem 'rspec', '~> 2.4'
  gem 'webmock', '~> 1.6'
  gem 'imagesize', '~> 0.1'
end

group :production do
  gem 'newrelic_rpm', :require => false
end
