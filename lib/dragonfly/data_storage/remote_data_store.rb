require 'typhoeus'

module Dragonfly
  module DataStorage
    #class Forbidden < StandardError; end
    
    class RemoteDataStore
      include Configurable
      
      configurable_attr :cookie_str
      
      def store(temp_object, opts={})
        raise "Sorry friend, this datastore is read-only."
      end

      def retrieve(uid)
        response = Typhoeus::Request.get uid, :headers => { 'Cookie' => cookie_str || '' }
        unless response.success?
          #raise Forbidden if response.code == 403
          raise DataNotFound
        end
        
        [
          response.body,      # either a File, String or Tempfile
          {}                  # Hash with optional keys :meta, :name, :format
        ]
      end

      def destroy(uid)
        raise "Sorry friend, this datastore is read-only."
      end
    end
  end
end
