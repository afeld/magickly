# magickly

A simple wrapper of Imagemagick which handles caching, c/o the Dragonfly gem.

## Install

    $ gem install magickly

## Usage

A few options:

### A. Run the app directly

    $ magickly

The app can be accessed at [http://localhost:4567](http://localhost:4567)

### B. Use as an endpoint in another Rack app

As an example, to have magickly accessible at `/images` in a Rails app:

    # Gemfile
    gem 'magickly', '~> 0.1'
    
    # config/routes.rb
    match '/images', :to => MagicklyApp, :anchor => false

For more info, see [Rails Routing from the Outside In](http://guides.rubyonrails.org/routing.html#routing-to-rack-applications) or Michael Raidel's [Mount Rails apps in Rails 3](http://inductor.induktiv.at/blog/2010/05/23/mount-rack-apps-in-rails-3/).

## Contributing to magickly
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Aidan Feldman. See LICENSE.txt for
further details.
