Magickly.dragonfly.configure do |c|
  c.job :brightness_contrast do |val|
    raise ArgumentError, "argument must be of the format '<int>[%]x<int>[%]'" unless val =~ /^-?\d+%?(x-?\d+%?)?$/
    process :convert, "-brightness-contrast #{val}"
  end
  
  c.job :saturation do |percentage|
    raise ArgumentError, "percentage must be a positive integer" unless percentage =~ /^\d+$/
    process :convert, "-modulate 100,#{percentage}"
  end
  
  c.job :resize_with_blur do |size|
    process :convert, "-filter Gaussian -resize #{size}"
  end
  
  c.job :tilt_shift do |coefficients|
    coefficients = '4,-4,1' if coefficients == 'true'
    raise ArgumentError, "coefficients must be of the format '<decimal>,<decimal>,<decimal>'" unless coefficients =~ /^(-?\d+(\.\d+)?,){2}-?\d+(\.\d+)?$/
    
    # note: can be made faster by decreasing sigma passed to option:compose:args
    action = "\\( +clone -sparse-color Barycentric '0,0 black 0,%h white' -function polynomial #{coefficients} \\) -compose Blur -set option:compose:args 8 -composite"
    process :convert, action
  end
  
  # thanks to http://www.melissaevans.com/tutorials/pop-art-inspired-by-lichtenstein
  c.job :halftone do |threshold|
    threshold = 50 if threshold == 'true'
    process :convert, "-white-threshold #{threshold.to_i}% -gaussian-blur 2 -ordered-dither 8x1"
  end
  
  # thanks to http://www.photoshopsupport.com/tutorials/or/cross-processing.html
  c.job :cross_process do
    process :convert, "-channel Red -sigmoidal-contrast 6,50% -channel Blue -level 25%\\! -channel Green -sigmoidal-contrast 5,45% \\( +clone +matte -fill yellow -colorize 4% \\) -compose overlay -composite"
  end
  
  ## thanks to https://github.com/soveran/lomo
  c.job :lomo do |modulate_params|
    if modulate_params == 'true'
      modulate_params = '100,150'
    elsif modulate_params =~ /^\d+,\d+$/
      # valid params
    else
      raise ArgumentError, "modulate_params must be of the format '<int>,<int>'"
    end
    
    lomo_mask = File.join(File.dirname(__FILE__), 'images', 'lomo_mask.png')
    process :convert, "\\( +clone -unsharp 1 -contrast -contrast -modulate #{modulate_params} \\( #{lomo_mask} -resize #{@job.width}x#{@job.height}\\! \\) -compose overlay -composite \\) -compose multiply -composite"
  end

  # thanks to Jesse Chan-Norris - http://jcn.me/
  c.job :jcn do
    process :greyscale
    @job = @job.halftone(99)
  end
  
  
  ## thanks to Fred Weinhaus (http://www.fmwconcepts.com/imagemagick) for the following: ##
  
  c.job :glow do |args|
    if args == 'true'
      amount = 1.2
      softening = 20
    elsif args =~ /^(\d+\.\d+?),(\d+)$/ && $1.to_f >= 1.0 && $2.to_i >= 0
      amount = $1
      softening = $2
    else
      raise ArgumentError, "args must be of the form <amount(float)>,<softening(int)>"
    end
    
    process :convert, "\\( +clone -evaluate multiply #{amount} -blur 0x#{softening} \\) -compose plus -composite"
  end
  
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

  c.job :output do |val|
    encode val.to_sym
  end
end
