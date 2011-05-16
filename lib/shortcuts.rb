Magickly.dragonfly.configure do |c|
  c.job :resize_with_blur do |size|
    process :convert, "-filter Gaussian -resize #{size}"
  end
  
  c.job :tilt_shift do |coefficients|
    if coefficients == 'true'
      # use default polynomial coefficients
      coefficients = "2,-2,0.5"
    end
    
    action = "\\( +clone -sparse-color Barycentric '0,0 black 0,%[fx:h-1] white' -function polynomial #{coefficients} \\) -compose Blur -set option:compose:args 15 -composite"
    process :convert, action
  end
end
