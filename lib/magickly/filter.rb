require 'active_support/core_ext/string'

module Magickly
  # attr_accessor :filters
  @filters = []
  
  def self.filters
    @filters
  end
  
  class Filter
    class << self
      def inherited(subclass)
        Magickly.filters << subclass.to_s.underscore
      end
    
      def call(options={})
        raise "#{self.class.to_s} needs to override the #call method."
      end
    end
  end
end
