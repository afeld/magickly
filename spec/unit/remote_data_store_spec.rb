require 'spec_helper'

describe Dragonfly::DataStorage::RemoteDataStore do
  describe '#base_uri=' do
    it "should persist the base_uri when set" do
      uri = "http://www.foo.com"
      datastore = Dragonfly::DataStorage::RemoteDataStore.new
      datastore.base_uri = uri

      Dragonfly::DataStorage::RemoteDataStore::Fetcher.base_uri.should eq uri
      datastore.base_uri.should eq uri
    end

    it "should use the base_uri when making requests" do
      base_uri = 'http://www.foo.com'
      image_name = 'imagemagick.png'
      url = "#{base_uri}/#{image_name}"
      stub_request(:get, url)

      datastore = Dragonfly::DataStorage::RemoteDataStore.new
      datastore.base_uri = base_uri
      
      datastore.retrieve "/#{image_name}"
      a_request(:get, url).should have_been_made.once
    end
  end
end

