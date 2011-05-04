require 'spec_helper'

describe Magickly do
  describe ".jobs" do
    it "should return an array of job names" do
      jobs = Magickly.jobs
      jobs.should be_kind_of Array
      jobs.each{|j| j.should be_kind_of String }
    end
  end
  
  describe ".process_src" do
    it "retrieves an image with no options" do
      image_url = "http://www.foo.com/imagemagick.png"
      image_path = File.join(File.dirname(__FILE__), '..', 'support', 'imagemagick.png')
      stub_request(:get, image_url).to_return(:body => File.new(image_path))
      
      returned_image = Magickly.process_src(image_url)
      
      returned_image.should_not be_nil
      
      # check that the returned file is identical to the original
      IO.read(returned_image.file.path).should eq IO.read(image_path)
    end
  end
  
  describe ".process_image" do
    it "doesn't modify the image if given no options"
  end
end
