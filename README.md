# magickly

A service for image manipulation - built as a simple wrapper of Imagemagick which handles caching, c/o the [Dragonfly](http://markevans.github.com/dragonfly/) gem.

---
## Usage

Say the base URL is the hosted version of this app, [magickly.heroku.com](http://magickly.heroku.com).  The image URL is appended to the query string as a `src=`, followed by any of the supported imagemagick operations.

### Parameters (required)

**src** - the URL of the original image

### Parameters (optional)

***See the [Dragonfly documentation](http://markevans.github.com/dragonfly/file.Processing.html#ImageMagickProcessor) for more details about the*** geometry***.***

**flip**=true

![flipped imagemagick logo](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&flip=true)

[http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png& **flip=true** ](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&flip=true)

**flop**=true

![flopped imagemagick logo](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&flop=true)

[http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&**flop=true**](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&flop=true)

**greyscale**=true

![flopped imagemagick logo](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&greyscale=true)

[http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&**greyscale=true**](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&greyscale=true)

**resize**=*geometry*

![resized imagemagick logo](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&resize=100x100)

[http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&**resize=100x100**](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&resize=100x100)

**rotate**=*degrees*

![rotated imagemagick logo](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&rotate=45)

[http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&**rotate=45**](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&rotate=45)

**thumb**=*geometry*

![thumbnail of imagemagick logo](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&thumb=200x100%23)

[http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&**thumb=200x100%23**](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&thumb=200x100%23)

(note: the `%23` in the geometry string above is an encoded '`#`')

---
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
    match '/magickly', :to => Magickly::App, :anchor => false

For more info, see [Rails Routing from the Outside In](http://guides.rubyonrails.org/routing.html#routing-to-rack-applications) or Michael Raidel's [Mount Rails apps in Rails 3](http://inductor.induktiv.at/blog/2010/05/23/mount-rack-apps-in-rails-3/).

---
## Contributing to magickly
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Credits

Created by [Aidan Feldman](http://www.aidanfeldman.com) at [Jux.com](http://www.jux.com).  Thanks to [Mark Evans](https://github.com/markevans) for all his hard work on [Dragonfly](http://markevans.github.com/dragonfly/).

