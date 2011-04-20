require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MagicklyApp do
  include Rack::Test::Methods
  
  def app
    MagicklyApp
  end
  
  describe "GET /" do
    
    it "should display the demo page for no params" do
      get '/'
      last_response.should be_ok
      # TODO test that it renders the view
    end
    
    it "retrieves an image with no options" do
      image_url = "http://www.foo.com/imagemagick.png"
      image_path = File.join(File.dirname(__FILE__), '..', 'support', 'imagemagick.png')
      stub_request(:get, image_url).to_return(:body => File.new(image_path))
      
      get "/?src=#{image_url}"
      
      a_request(:get, image_url).should have_been_made.once
      last_response.should be_ok
      
      # check that the returned file is identical to the original
      last_response.body.should eq IO.read(image_path)
    end
    
    it "resizes an image" do
      image_url = "http://www.foo.com/imagemagick.png"
      image_path = File.join(File.dirname(__FILE__), '..', 'support', 'imagemagick.png')
      stub_request(:get, image_url).to_return(:body => File.new(image_path))
      width = 100
      
      get "/?src=#{image_url}&resize=#{width}x"
      
      a_request(:get, image_url).should have_been_made.once
      last_response.should be_ok
      
      ImageSize.new(last_response.body).get_width.should eq width
    end
    
  end
  
  describe "GET /filters" do
    it "should return the list of filters" do
      get "/filters"
      last_response.body.should eq Magickly.filters.inspect
    end
    
    it "should return my filter" do
      expect { AppSpecFilter }.to raise_error(NameError)
      get "/filters"
      last_response.body.should_not include 'app_spec_filter'
      
      class AppSpecFilter < Magickly::Filter
      end
      
      get "/filters"
      filters = Kernel.eval(last_response.body)
      filters.should be_a Array
      filters.should include 'app_spec_filter'
    end
  end
end
