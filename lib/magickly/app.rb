module Magickly
  class App #< ::MagicklyApp
    @dragonfly = Dragonfly[:images].configure_with(:imagemagick)
    @dragonfly.configure do |c|
      c.datastore = Dragonfly::DataStorage::RemoteDataStore.new
      c.log = Logger.new($stdout)
    end
    
    class << self
      def dragonfly
        @dragonfly
      end
      
      def process_src(src, options={})
        raise ArgumentError.new("src needed") if src.blank?
        escaped_src = URI.escape(src)
        image = Magickly::App.dragonfly.fetch(escaped_src)

        process_image(image, options)
      end
      
      def process_image(image, options={})
        options.each do |method, val|
          if val == 'true'
            image = image.process method
          else
            image = image.process method, val
          end
        end

        image
      end
    end
  end
end
