require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Magickly::App do
  include Rack::Test::Methods
  
  def app
    Magickly::App
  end
  
  describe "GET /" do
    def setup_image(host='http://www.foo.com')
      @image_filename = 'imagemagick.png'
      @image_url = "#{host}/#{@image_filename}"
      @image_path = File.join(File.dirname(__FILE__), '..', 'support', @image_filename)
      @stub = Typhoeus::HydraMock.new(@image_url, :get)
      @stub.and_return( Typhoeus::Response.new(:body => File.read(@image_path)) )
    end
    
    it "should display the demo page for no params" do
      get '/'
      last_response.should be_ok
      # TODO test that it renders the view
    end
    
    it "retrieves an image with no options" do
      setup_image
      
      get "/?src=#{@image_url}"
      
      # a_request(:get, @image_url).should have_been_made.once
      last_response.should be_ok
      
      # check that the returned file is identical to the original
      compare_binary(last_response.body, IO.read(@image_path))
    end
    
    it "should ignore unused params" do
      setup_image
      
      get "/?src=#{@image_url}&bad_param=666"
      
      # a_request(:get, @image_url).should have_been_made.once
      last_response.should be_ok
      
      # check that the returned file is identical to the original
      compare_binary(last_response.body, IO.read(@image_path))
    end
    
    it "retrieves an image at a relative URI" do
      setup_image "http://#{Rack::Test::DEFAULT_HOST}"
      
      get "/?src=/#{@image_filename}"
      
      # a_request(:get, @image_url).should have_been_made.once
      last_response.should be_ok
      
      # check that the returned file is identical to the original
      compare_binary(last_response.body, IO.read(@image_path))
    end
    
    it "resizes an image" do
      setup_image
      width = 100
      
      get "/?src=#{@image_url}&resize=#{width}x"
      
      # a_request(:get, @image_url).should have_been_made.once
      last_response.should be_ok
      ImageSize.new(last_response.body).get_width.should eq width
    end
    
    it "should use my Dragonfly shortcut with no arguments" do
      setup_image
      width = 100
      shortcut = :filter_with_no_arguments
      Magickly.dragonfly.configure do |c|
        c.job shortcut do
          process :convert, "-filter Gaussian -resize #{width}x"
        end
      end
      
      get "/?src=#{@image_url}&#{shortcut}=true"
      
      last_response.should be_ok
      ImageSize.new(last_response.body).get_width.should eq width
    end
    
    it "should use my Dragonfly shortcut with one argument" do
      setup_image
      width = 100
      shortcut = :filter_with_one_argument
      Magickly.dragonfly.configure do |c|
        c.job shortcut do |size|
          process :thumb, size
        end
      end
      
      get "/?src=#{@image_url}&#{shortcut}=#{width}x"
      
      last_response.should be_ok
      ImageSize.new(last_response.body).get_width.should eq width
    end
  end
end

describe MagicklyApp do
  include Rack::Test::Methods
  
  def app
    MagicklyApp
  end
  
  describe "backward compatibility test" do
    
    it "should display the demo page for no params" do
      get '/'
      last_response.should be_ok
      # TODO test that it renders the view
    end
    
  end
end
