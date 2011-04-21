require 'active_support/core_ext/string'

module Magickly
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
