# magickly [![Build Status](http://travis-ci.org/afeld/magickly.png)](http://travis-ci.org/afeld/magickly)

A service for image manipulation - built as a simple wrapper of Imagemagick which handles caching, c/o the [Dragonfly](http://markevans.github.com/dragonfly/) gem.

Say the base URL is the hosted version of this app, [magickly.heroku.com](http://magickly.heroku.com).  The image URL is appended to the query string as a `src=`, followed by any of the supported operations below.  Multiple operations can be combined, and will be applied in order.

If no query params are provided, a simple sandbox page is displayed.  Try it here:

[magickly.heroku.com](http://magickly.heroku.com)

## Parameters

*See the [Dragonfly documentation](http://markevans.github.com/dragonfly/file.ImageMagick.html) for more details about the permitted* `geometry` *values.*

### src=*url* (required)

The URL of the original image.

### brightness_contrast=*brightness* x *contrast*

*brightness* and *contrast* are percentage change, between -100 and 100.  For example, to increase contrast by 20% but leave brightness unchanged, use `brightness_contrast=0x20`.

![tanned imagemagick logo](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&brightness_contrast=-10x50)

[http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&brightness_contrast=-10x50](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&brightness_contrast=-10x50)

### flip=true

![flipped imagemagick logo](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&flip=true)

[http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&flip=true](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&flip=true)

### flop=true

![flopped imagemagick logo](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&flop=true)

[http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&flop=true](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&flop=true)

### glow=*amount*,*softness*

where `amount` is a float >= 1.0, and `softness` is an int >= 0.

![glowing imagemagick logo](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&glow=1.2,20)

[http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&glow=1.2,20](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&glow=1.2,20)

### greyscale=true

![flopped imagemagick logo](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&greyscale=true)

[http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&greyscale=true](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&greyscale=true)

### halftone=*threshold*

where *threshold* is a value between 0 and 100.

![halftone imagemagick logo](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&halftone=60)

[http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&halftone=60](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&halftone=60)

### resize=*geometry*

![resized imagemagick logo](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&resize=100x100)

[http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&resize=100x100](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&resize=100x100)

### rotate=*degrees*

![rotated imagemagick logo](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&rotate=45)

[http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&rotate=45](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&rotate=45)

### tilt_shift=true

![tilt-shifted imagemagick logo](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&tilt_shift=true)

[http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&tilt_shift=true](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&tilt_shift=true)

### thumb=*geometry*

![thumbnail of imagemagick logo](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&thumb=200x100%23)

[http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&thumb=200x100%23](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&thumb=200x100%23)

(note: the `%23` in the geometry string above is an encoded '`#`', which tells Dragonfly to fill the dimensions and crop)

### two_color=true

![two color imagemagick logo](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&two_color=true)

[http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&two_color=true](http://magickly.heroku.com/?src=http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Imagemagick-logo.png/200px-Imagemagick-logo.png&two_color=true)

## Customization

In addition to the available listed above, custom "shortcuts" can be created to perform arbitrary imagemagick operations.  For example, to create a shortcut called `resize_with_blur`:

    # somewhere in your app configuration, i.e. config/initializers/magickly.rb for a Rails 3 app
    Magickly.dragonfly.configure do |c|
      c.job :resize_with_blur do |size|
        process :convert, "-filter Gaussian -resize #{size}"
      end
    end

which can then be used with the query string `?src=...&resize_with_blur=200x`.  Note that magickly will pass the value of the query param to the block as a single string.

See the [Dragonfly documentation](http://markevans.github.com/dragonfly/file.GeneralUsage.html#Shortcuts) for more info on "shortcuts", and the [shortcuts.rb](https://github.com/afeld/magickly/blob/master/lib/shortcuts.rb) file for examples.

## Installation

Requires Imagemagick >= v6.2.4.

    $ gem install magickly

## Running the App

A few options:

### A. Run the app directly

    $ magickly

The app can be accessed at [http://localhost:4567](http://localhost:4567)

### B. Use as an endpoint in another Rack app

As an example, to have magickly accessible at `/magickly` in a Rails app:

    # Gemfile
    gem 'magickly', '~> 1.1'
    
    # config/routes.rb
    match '/magickly', :to => Magickly::App, :anchor => false

For more info, see [Rails Routing from the Outside In](http://guides.rubyonrails.org/routing.html#routing-to-rack-applications) or Michael Raidel's [Mount Rails apps in Rails 3](http://inductor.induktiv.at/blog/2010/05/23/mount-rack-apps-in-rails-3/).

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

