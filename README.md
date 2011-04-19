# magickly

A service for image manipulation - built as a simple wrapper of Imagemagick which handles caching, c/o the [Dragonfly](http://markevans.github.com/dragonfly/) gem.

## Usage

Say the base URL is the hosted version of this app, [magickly.heroku.com](http://magickly.heroku.com).  The image URL is appended to the query string as a `src=`, followed by any of the supported imagemagick operations.  For example, you could get a 100x100 thumbnail of [the imagemagick logo](http://upload.wikimedia.org/wikipedia/commons/0/0d/Imagemagick-logo.png) like so:

[http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/0/0d/Imagemagick-logo.png&resize=100x100](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/0/0d/Imagemagick-logo.png&resize=100x100)

### Parameters (required)

**src** - the URL of the original image

### Parameters (optional):

See the [imagemagick command line params documentation](http://www.imagemagick.org/script/command-line-options.php) for details about allowed values.

**crop**

**flip**

**flop**

**greyscale**

**resize**

**rotate**

**thumb**


## Installation

    $ gem install magickly

## Running the App

A few options:

### A. Run the app directly

    $ magickly

The app can be accessed at [http://localhost:4567](http://localhost:4567)

### B. Use as an endpoint in another Rack app

As an example, to have magickly accessible at `/images` in a Rails app:

    # Gemfile
    gem 'magickly', '~> 0.1'
    
    # config/routes.rb
    match '/magickly', :to => MagicklyApp, :anchor => false

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
