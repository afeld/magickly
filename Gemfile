source 'https://rubygems.org'

gemspec

gem 'rake'
gem 'rack-cache', :require => 'rack/cache'

group :development, :test do
  gem 'rack-test'
  gem 'rspec'
  gem 'webmock'
  gem 'fastimage'
end

group :production do
  gem 'newrelic_rpm', :require => false
end
