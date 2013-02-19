This gem respects [semantic versioning](http://semver.org/).

# 1.4.0 (1/26/12)

[commits](https://github.com/afeld/magickly/compare/v1.3.0...v1.4.0)

* SECURITY: don't pass cookies to image request (tolsen)
* removed async support (for now) - needs more extensive testing
* added /q syntax as alternative to query params (tolsen)
* added JCN effect

# 1.2.1 (12/21/11)

[commits](https://github.com/afeld/magickly/compare/v1.2.0...v1.2.1)

* made compatible w/ Dragonfly v0.9.8 (tolsen)

# 1.3.0 (9/5/11) - YANKED

[commits](https://github.com/afeld/magickly/compare/v1.2.0...v1.3.0)

* added asynchronous support when using Ruby 1.9 or JRuby
* reduced gem dependencies

# 1.2.0 (6/28/11)

[commits](https://github.com/afeld/magickly/compare/v1.1.3...v1.2.0)

* add /analyze and /analyze/:analyzer endpoints
* fix for negative values for brightness_contrast
* validation & specs for existing shortcuts
* added shortcuts:
    * color_palette (analyzer)
    * cross_process
    * glow
    * halftone
    * lomo
    * saturation
    * two_color

# 1.1.3 (5/26/11)

[commits](https://github.com/afeld/magickly/compare/v1.1.2...v1.1.3)

* make tilt-shift faster
* add brightness_contrast shortcut

# 1.1.2 (5/16/11)

[commits](https://github.com/afeld/magickly/compare/v1.1.1...v1.1.2)

* remove rack-cache - this is not the responsibility of the gem
* use NewRelic, if configured
* ignore params that do not correspond to jobs or processor methods
* get job/processor commands from Dragonfly (new in v0.9.1)
* enable tilt_shift shortcut (possible after `convert` argument order change in Dragonfly v0.9.0)

# 1.1.1 (4/28/11)

[commits](https://github.com/afeld/magickly/compare/v1.1.0...v1.1.1)

* cross-compatibility fix for Ruby 1.8/1.9 regarding the checking of available methods from the Processor
* Addressable now required properly when included as a gem

# 1.1.0 (4/26/11)

[commits](https://github.com/afeld/magickly/compare/v1.0.0...v1.1.0)

* make underlying Dragonfly application accessible for external configuration
* added some example Dragonfly shortcuts
* major refactoring: namespacing inside of Magickly module (should be entirely backwards compatible)

# 1.0.0 (4/19/11)

* initial release
