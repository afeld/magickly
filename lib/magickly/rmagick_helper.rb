module Magickly
  module RmagickHelper
    # http://blog.kellishaver.com/image-color-analysis-with-rmagick/
    def self.to_hex_val(color_int)
      sprintf('%02x', color_int / 256).upcase
    end

    def self.to_hex(pixel)
      [
        to_hex_val(pixel.red),
        to_hex_val(pixel.green),
        to_hex_val(pixel.blue)
      ].join
    end
  end
end
