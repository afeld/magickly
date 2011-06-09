require 'spec_helper'

describe "Dragonfly shortcuts" do
  describe :color_palette do
    it "should return an array" do
      image_path = File.join(File.dirname(__FILE__), '..', 'support', 'imagemagick.png')
      image = Magickly.dragonfly.fetch_file(image_path)
      palette = image.color_palette
      palette.should be_an Array
    end
    
    it "should have the default number of colors" do
      image_path = File.join(File.dirname(__FILE__), '..', 'support', 'imagemagick.png')
      image = Magickly.dragonfly.fetch_file(image_path)
      palette = image.color_palette
      palette.length.should eq Magickly::COLOR_PALETTE_SIZE
    end
  end
end
