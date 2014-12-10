require 'spec_helper'

describe Dragonfly::DataStorage::RemoteDataStore do
  describe '#retrieve' do
    it "should successfully make requests" do
      url = "http://www.foo.com/iamgemagick.png"
      stub_request(:get, url)
      datastore = Dragonfly::DataStorage::RemoteDataStore.new

      datastore.retrieve url
      expect(a_request(:get, url)).to have_been_made.once
    end

    it "should return the image" do
      url = "http://www.foo.com/imagemagick.png"
      image_path = File.join(File.dirname(__FILE__), '..', 'support', 'imagemagick.png')
      stub_request(:get, url).to_return(:body => File.new(image_path))
      datastore = Dragonfly::DataStorage::RemoteDataStore.new

      image,extra = datastore.retrieve(url)
      expect(image).to eq IO.read(image_path)
    end

    it "should fetch the image based on the url_host variable" do
      path = "foo/bar/iamgemagick.png"
      url_host = "http://www.foo.com/"
      url = url_host + path
      stub_request(:get, url)

      datastore = Dragonfly::DataStorage::RemoteDataStore.new
      datastore.configure do |c|
        c.url_host = url_host
      end

      datastore.retrieve path
      expect(a_request(:get, url)).to have_been_made.once
    end
  end
end

