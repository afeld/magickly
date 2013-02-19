module Magickly
  class App < Sinatra::Base
    RESERVED_PARAMS = ['src']
    DEMO_IMAGE = 'http://farm4.static.flickr.com/3351/3450592233_c29fde01ef_z.jpg'
    
    enable :logging
    set :root, File.join(File.dirname(__FILE__), '..')
    set :homepage, "http://github.com/afeld/magickly"
    
    configure :production do
      require 'newrelic_rpm' if ENV['NEW_RELIC_ID']
    end
    
    before do
      # redirect to MAGICKLY_APP_DOMAIN, if specified
      app_host = ENV['MAGICKLY_APP_DOMAIN']
      if app_host && request.host != app_host
        request_host_with_port = request.env['HTTP_HOST']
        redirect request.url.sub(request_host_with_port, app_host), 301
      end
      
      # parse query params so they are ordered
      @options = ActiveSupport::OrderedHash.new
      request.query_string.split('&').each do |e|
        k,v = e.split('=')
        @options[k] = URI.unescape(v) unless RESERVED_PARAMS.include?(k)
      end
    end
    
    get '/' do
      process_src_or_display_demo params[:src], @options
    end

    get '/q/*' do 
      src = nil
      opts = ActiveSupport::OrderedHash.new
      path = env['servlet_request'].try(:get_request_uri) || request.path_info
      splat = path.sub /^.*?\/q\//, ''
      
      splat.split('/').each_slice(2) do |k, v|
        if RESERVED_PARAMS.include? k
          if k == 'src'
            src = URI.unescape(v)
            # slashes come in double-escaped by Apache so we
            # need to unescape again
            src = URI.unescape(src) if src =~ /%2F/
          end
        else
          opts[k] = URI.unescape(v)
        end
      end

      process_src_or_display_demo src, opts
    end
    
    get '/analyze' do
      @analyzers = Magickly.dragonfly.analyser_methods
      @analyzers.sort!{|m1, m2| m1.to_s <=> m2.to_s }
      erb :analyzers
    end
    
    get '/analyze/:name' do |method|
      src = params[:src]
      if src
        url = uri_to_url(src)
        image = Magickly.process_src(url, @options)
        
        begin
          output = image.send(method.to_sym)
        rescue NoMethodError
          method = method.to_s + '?'
          output = image.send(method.to_sym)
        end
        
        output.is_a?(String) ? output : output.to_json
      else
        status 400
        "Please provide an image URL with the src parameter."
      end
    end

    def process_src_or_display_demo src, options
      if src
        # process image
        url = uri_to_url src
        image = Magickly.process_src(url, options)
        
        status, headers, body = image.to_response(env)

        if options['download'].try(:downcase) == 'true'
          filename = image.uid ? File.basename(image.uid) : "picture.#{image.format}"
          headers = headers.merge('Content-Disposition' => "attachment; filename=\"#{filename}\"",
                                  'Content-Type' => 'application/octet-stream')
        end

        [status, headers, body]
      else
        # display demo page
        
        # get combined list of jobs and processor methods
        @methods = ( Magickly.dragonfly.job_methods | Magickly.dragonfly.processor_methods )
        @methods.sort!{|m1, m2| m1.to_s <=> m2.to_s }
        erb :index
      end
    end
    
    def uri_to_url(uri)
      url = Addressable::URI.parse(uri)
      url.site ||= Addressable::URI.parse(request.url).site
      url.to_s
    end
    
    # start the server if ruby file executed directly
    run! if __FILE__ == $0
  end
end

# <b>DEPRECATED:</b> Please use <tt>Magickly::App</tt> instead.
class MagicklyApp < Magickly::App
  def self.run
    warn "This has been deprecated - please use Magickly::App.run"
    super
  end
end
