This gem respects [semantic versioning](http://semver.org/).

# HEAD

* add /analyze endpoint
* add color_palette analyzer

# 1.1.3 (5/26/11)

* make tilt-shift faster
* add brightness_contrast shortcut

# 1.1.2 (5/16/11)

* remove rack-cache - this is not the responsibility of the gem
* use NewRelic, if configured
* ignore params that do not correspond to jobs or processor methods
* get job/processor commands from Dragonfly (new in v0.9.1)
* enable tilt_shift shortcut (possible after `convert` argument order change in Dragonfly v0.9.0)

# 1.1.1 (4/28/11)

* cross-compatibility fix for Ruby 1.8/1.9 regarding the checking of available methods from the Processor
* Addressable now required properly when included as a gem

# 1.1.0 (4/26/11)

* make underlying Dragonfly application accessible for external configuration
* added some example Dragonfly shortcuts
* major refactoring: namespacing inside of Magickly module (should be entirely backwards compatible)

# 1.0.0 (4/19/11)

* initial release
