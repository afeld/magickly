require 'spec_helper'
require 'uri'

describe Magickly::App do
  include Rack::Test::Methods

  def app
    Magickly::App
  end

  def setup_image(host='http://www.foo.com')
    @image_filename = 'imagemagick.png'
    @image_url = "#{host}/#{@image_filename}"
    @escaped_image_url = URI.escape @image_url, URI::REGEXP::PATTERN::RESERVED
    @image_path = File.join(File.dirname(__FILE__), '..', 'support', @image_filename)
    stub_request(:get, @image_url).to_return(:body => File.new(@image_path))
  end

  def get_image(uri)
    get(uri)
    file = Tempfile.new('testimage')
    file.write(last_response.body)
    file.rewind

    file
  end

  describe "GET /" do
    it "should display the demo page for no params" do
      get '/'
      expect(last_response.status).to eq(200)
      # TODO test that it renders the view
    end

    it "retrieves an image with no options" do
      setup_image

      get "/?src=#{@image_url}"

      expect(a_request(:get, @image_url)).to have_been_made.once
      expect(last_response.status).to eq(200)

      # check that the returned file is identical to the original
      compare_binary(last_response.body, IO.read(@image_path))
    end

    it "should ignore unused params" do
      setup_image

      get "/?src=#{@image_url}&bad_param=666"

      expect(a_request(:get, @image_url)).to have_been_made.once
      expect(last_response.status).to eq(200)

      # check that the returned file is identical to the original
      compare_binary(last_response.body, IO.read(@image_path))
    end

    it "retrieves an image at a relative URI" do
      setup_image "http://#{Rack::Test::DEFAULT_HOST}"

      get "/?src=/#{@image_filename}"

      expect(a_request(:get, @image_url)).to have_been_made.once
      expect(last_response.status).to eq(200)

      # check that the returned file is identical to the original
      compare_binary(last_response.body, IO.read(@image_path))
    end

    it "resizes an image" do
      setup_image
      width = 100

      file = get_image "/?src=#{@image_url}&resize=#{width}x"

      expect(a_request(:get, @image_url)).to have_been_made.once
      expect(last_response.status).to eq(200)
      expect(file).to have_width(width)
    end

    it "outputs an image in a new format" do
      setup_image

      file = get_image "/?src=#{@image_url}&output=gif"

      expect(a_request(:get, @image_url)).to have_been_made.once
      expect(FastImage.type(file)).to eq(:gif)
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

      file = get_image "/?src=#{@image_url}&#{shortcut}=true"

      expect(last_response.status).to eq(200)
      expect(file).to have_width(width)
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

      file = get_image "/?src=#{@image_url}&#{shortcut}=#{width}x"

      expect(last_response.status).to eq(200)
      expect(file).to have_width(width)
    end
  end

  describe "GET /q" do

    it "resizes an image" do
      setup_image
      width = 100

      file = get_image "/q/src/#{@escaped_image_url}/resize/#{width}x"

      expect(a_request(:get, @image_url)).to have_been_made.once
      expect(last_response.status).to eq(200)
      expect(file).to have_width(width)
    end

  end

  describe "GET /qe" do

    it "resized an image" do
      setup_image
      width = 100

      # This is just Base64.urlsafe_encode64 which is not available in ruby 1.8.7
      encoded = ["src/#{@escaped_image_url}/resize/#{width}x"].pack("m0").tr("+/", "-_")

      # Strip the newlines from the encoding since m0 should mean no newlines
      # but doesn't seem to be doing that in ruby 1.8.7
      encoded = encoded.tr("\n", "")

      file = get_image "/qe/#{encoded}"

      expect(a_request(:get, @image_url)).to have_been_made.once
      expect(last_response.status).to eq(200)
      expect(file).to have_width(width)
    end

  end

  describe "GET /analyze" do
    it "retrieves the mime_type of an image" do
      setup_image

      get "/analyze/mime_type?src=#{@image_url}"

      expect(a_request(:get, @image_url)).to have_been_made.once
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq 'image/png'
    end

    it "retrieves the color palette of an image" do
      setup_image

      get "/analyze/color_palette?src=#{@image_url}"

      expect(a_request(:get, @image_url)).to have_been_made.once
      expect(last_response.status).to eq(200)
      expect(last_response.body).to_not be_empty
      json = ActiveSupport::JSON.decode(last_response.body)
      expect(json).to be_an Array
      expect(json.size).to eq 5
    end

    it "should handle analyzer methods where the question mark is missing" do
      expect(Magickly.dragonfly.analyser_methods.map{|m| m.to_s }).to include 'landscape?'
      setup_image

      get "/analyze/landscape?src=#{@image_url}"

      expect(a_request(:get, @image_url)).to have_been_made.once
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include('false')
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
      expect(last_response.status).to eq(200)
      # TODO test that it renders the view
    end

  end
end
