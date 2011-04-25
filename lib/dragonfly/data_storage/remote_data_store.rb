require 'httparty'

module Dragonfly
  module DataStorage
    #class Forbidden < StandardError; end
    
    class RemoteDataStore
      include Configurable
      
      class Fetcher
        include HTTParty
      end
      
      configurable_attr :cookie_str
      
      def base_uri=(uri)
        Fetcher.base_uri uri
      end

      def base_uri
        Fetcher.base_uri
      end

      def store(temp_object, opts={})
        raise "Sorry friend, this datastore is read-only."
      end

      def retrieve(uid)
        response = Fetcher.get uid, :headers => {'cookie' => cookie_str || ''}
        unless response.ok?
          #raise Forbidden if response.code == 403
          raise DataNotFound
        end
        
        content = response.body
        extra_data = {}
        [
          content,            # either a File, String or Tempfile
          extra_data          # Hash with optional keys :meta, :name, :format
        ]
      end

      def destroy(uid)
        raise "Sorry friend, this datastore is read-only."
      end
    end
  end
end
