require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MagicklyApp do
  include Rack::Test::Methods
  
  def app
    MagicklyApp
  end
  
  it "says hello" do
    pending 'need to add homepage'
    
    get '/'
    last_response.should be_ok
    last_response.body.should == 'Hello World'
  end
  
  it "retrieves an image with no options" do
    image_url = "http://www.foo.com/imagemagick.png"
    image_path = File.join(File.dirname(__FILE__), '..', 'support', 'imagemagick.png')
    stub_request(:get, image_url).to_return(:body => File.new(image_path))
    
    get "/?src=#{image_url}"
    
    a_request(:get, image_url).should have_been_made.once
    last_response.should be_ok
    
    # check that the returned file is identical to the original
    last_response.body.should eq IO.binread(image_path)
  end
end
