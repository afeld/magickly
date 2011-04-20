require 'spec_helper'

describe Magickly::Filter do
  it "should add subclasses to the list of filters" do
    expect { FilterSpecFilter }.to raise_error(NameError)
    Magickly.filters.should_not include 'filter_spec_filter'
    
    # careful that this global is not already defined...
    class FilterSpecFilter < Magickly::Filter
    end
    
    Magickly.filters.should include 'filter_spec_filter'
  end
  
  it "should include namespace in listed filters" do
    expect { FilterSpec::MyFilter }.to raise_error(NameError)
    Magickly.filters.should_not include 'filter_spec/my_filter'
    
    module FilterSpec
      class MyFilter < Magickly::Filter
      end
    end
    
    Magickly.filters.should include 'filter_spec/my_filter'
  end
  
  it "should raise an exception when the filter has does not override .call" do
    expect { FilterWithoutCall }.to raise_error(NameError)
    
    class FilterWithoutCall < Magickly::Filter
    end
    
    expect { FilterWithoutCall.call }.to raise_error
  end
  
  it "should not raise an exception when the filter has overridden .call" do
    expect { StubFilter.call }.to_not raise_error
  end
end
