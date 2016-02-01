describe Magickly::RmagickHelper do
  describe '.to_hex' do
    it "converts black correctly" do
      pixel = Magick::Pixel.from_color('black')
      expect(Magickly::RmagickHelper.to_hex(pixel)).to eq('000000')
    end

    it "converts white correctly" do
      pixel = Magick::Pixel.from_color('white')
      expect(Magickly::RmagickHelper.to_hex(pixel)).to eq('FFFFFF')
    end

    it "converts an intermediate color correctly" do
      pixel = Magick::Pixel.from_color('aquamarine')
      expect(Magickly::RmagickHelper.to_hex(pixel)).to eq('7FFFD4')
    end
  end
end
