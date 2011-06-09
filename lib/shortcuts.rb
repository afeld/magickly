Magickly.dragonfly.configure do |c|
  c.job :brightness_contrast do |val|
    process :convert, "-brightness-contrast #{val}"
  end
  
  c.job :resize_with_blur do |size|
    process :convert, "-filter Gaussian -resize #{size}"
  end
  
  c.job :tilt_shift do |coefficients|
    if coefficients == 'true'
      # use default polynomial coefficients
      coefficients = '4,-4,1'
    end
    
    # note: can be made faster by decreasing sigma passed to option:compose:args
    action = "\\( +clone -sparse-color Barycentric '0,0 black 0,%h white' -function polynomial #{coefficients} \\) -compose Blur -set option:compose:args 8 -composite"
    process :convert, action
  end
  
  c.job :color_palette_swatch do
    process :convert, "-resize 600x600 -colors #{Magickly::COLOR_PALETTE_SIZE} -unique-colors -scale 10000%"
    encode :gif
  end
  
  c.analyser.add :color_palette do |temp_object|
    output = `convert #{temp_object.path} -resize 600x600 -colors #{Magickly::COLOR_PALETTE_SIZE} -format %c -depth 8 histogram:info:-`
    
    palette = []
    output.scan(/\s+(\d+):[^\n]+#([0-9A-Fa-f]{6})/) do |count, hex|
      palette << { :count => count.to_i, :hex => hex }
    end
    palette
  end
end
