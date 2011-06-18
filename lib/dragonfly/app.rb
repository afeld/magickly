module Dragonfly
  class App
    # there is a pending pull request to add this method - see https://github.com/markevans/dragonfly/pull/100
    def analyser_methods
      analyser.functions.keys
    end
  end
end
