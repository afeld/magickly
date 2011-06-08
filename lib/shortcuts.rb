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
  
  c.analyser.add :color_palette do |temp_object|
    output = `convert #{temp_object.path} -resize 600x600 -colors 5 -format %c -depth 8 histogram:info:-`
    output.split('#').drop(1).map{|val| val[0...6] }
  end
end
