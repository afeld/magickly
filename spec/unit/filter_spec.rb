require 'spec_helper'

describe Magickly::Filter do
  it "should add subclasses to the list of filters" do
    Magickly.filters.should_not include 'my_filter'
    
    class MyFilter < Magickly::Filter
    end
    
    Magickly.filters.should include 'my_filter'
  end
end
