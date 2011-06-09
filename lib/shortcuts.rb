Magickly.dragonfly.configure do |c|
  c.job :brightness_contrast do |val|
    process :convert, "-brightness-contrast #{val}"
  end
  
  c.job :resize_with_blur do |size|
    process :convert, "-filter Gaussian -resize #{size}"
  end
  
  c.job :tilt_shift do |coefficients|
    coefficients = '4,-4,1' if coefficients == 'true'
    
    # note: can be made faster by decreasing sigma passed to option:compose:args
    action = "\\( +clone -sparse-color Barycentric '0,0 black 0,%h white' -function polynomial #{coefficients} \\) -compose Blur -set option:compose:args 8 -composite"
    process :convert, action
  end
  
  c.job :halftone do |threshold|
    threshold = 50 if threshold == 'true'
    process :convert, "-white-threshold #{threshold}% -gaussian-blur 2 -ordered-dither 6x1"
  end
  
  ## thanks to Fred Weinhaus (http://www.fmwconcepts.com/imagemagick) for the following: ##
  
  c.job :two_color do
    process :convert, "-background black -flatten +matte +dither -colors 2 -colorspace gray -contrast-stretch 0"
  end
  
  #########################################################################################
  
  c.job :color_palette_swatch do |count|
    count = Magickly::DEFAULT_PALETTE_COLOR_COUNT if count == 'true'
    
    process :convert, "-resize 600x600 -colors #{count} -unique-colors -scale 10000%"
    encode :gif
  end
  
  c.analyser.add :color_palette do |temp_object, num_colors|
    num_colors = num_colors.blank? ? Magickly::DEFAULT_PALETTE_COLOR_COUNT : num_colors.to_i
    output = `convert #{temp_object.path} -resize 600x600 -colors #{num_colors} -format %c -depth 8 histogram:info:-`
    
    palette = []
    output.scan(/\s+(\d+):[^\n]+#([0-9A-Fa-f]{6})/) do |count, hex|
      palette << { :count => count.to_i, :hex => hex }
    end
    palette
  end
end
