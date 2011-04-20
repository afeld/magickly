require 'active_support/core_ext/string'

module Magickly
  # attr_accessor :filters
  @filters = []
  
  def self.filters
    @filters
  end
  
  class Filter
    def self.inherited(subclass)
      Magickly.filters << subclass.to_s.underscore
    end
  end
end