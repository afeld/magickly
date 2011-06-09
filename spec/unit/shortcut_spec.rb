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
      palette.length.should eq Magickly::DEFAULT_PALETTE_COLOR_COUNT
    end
    
    it "should have the specified number of colors" do
      num_colors = 4
      num_colors.should_not eq Magickly::DEFAULT_PALETTE_COLOR_COUNT
      image_path = File.join(File.dirname(__FILE__), '..', 'support', 'imagemagick.png')
      
      image = Magickly.dragonfly.fetch_file(image_path)
      palette = image.color_palette(num_colors)
      
      palette.length.should eq num_colors
    end
  end
end
