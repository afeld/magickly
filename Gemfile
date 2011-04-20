source 'http://rubygems.org'
# Add dependencies required to use your gem here.
# Example:
#   gem 'activesupport', '>= 2.3.5'

gem 'sinatra', '~> 1.2.1', :require => 'sinatra/base'
gem 'rack-cache', :require => 'rack/cache'
gem 'dragonfly', '~> 0.8.2'

gem 'haml', '~> 3.0.25'
gem 'httparty', '~> 0.7.3'
gem 'activesupport', '>= 2.0.0', :require => false
gem 'i18n' # required for activesupport string extensions

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem 'jeweler', '~> 1.5'
  gem 'rcov', '>= 0'
end

group :development, :test do
  gem 'rack-test'
  gem 'rspec', '~> 2.4'
  gem 'webmock', '~> 1.6'
  gem 'imagesize', '~> 0.1'
  #gem 'ruby-debug19', :platforms => :ruby_19
  #gem 'ruby-debug', :platforms => :ruby_18
end
